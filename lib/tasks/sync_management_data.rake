namespace :qa do
  desc 'Sync specialist data from management'
  task sync_specialist_data: :environment do
    sync_user_data('specialist')
  end

  desc 'Sync dispatcher data from management'
  task sync_dispatcher_data: :environment do
    sync_user_data('dispatcher')
  end

  desc 'Sync support manager data from management'
  task sync_support_manager_data: :environment do
    sync_user_data('support_manager')
  end

  desc 'Sync engineer data from management'
  task sync_engineer_data: :environment do
    sync_user_data('engineer')
  end

  desc 'Sync auto data from management'
  task sync_auto_data: :environment do
    sync_auto_data
  end
end

def sync_user_data(role, options = {})
  options.reverse_merge!(per: 10)
  page = 1

  loop do
    result = get_user_data(role, options.merge(page: page))
    result.each do |attrs|
      update_user_data(attrs, role)
    end

    page += 1
    break if result.blank? || page > Settings.kalading_management_api.max_page
  end
end

def get_user_data(role, options = {})
  options.reverse_merge!(page: 1, per: 10)
  KaladingManagementApi.call('get', 'users', options.merge(role: role))
end

def update_user_data(attrs, role)
  user = User.where(internal_id: attrs['id']).first ||
         User.new(internal_id: attrs['id'], role: role, phone_num: attrs['phone_num'])
  user.name = attrs['name']

  if !user.save
    puts "Sync #{role} data failed. " \
         "Errors: #{user.errors.full_messages.join(', ')}. " \
         "Attributes: #{attrs}".colorize(:red)
  end
end

def sync_auto_data
  result = KaladingManagementApi.call('get', 'auto_sms')

  result.each do |auto_brand_attrs|
    sync_auto_data_with_message(auto_brand_attrs) do
      AutoBrand.sync(auto_brand_attrs['_id'], auto_brand_attrs)
    end

    auto_brand_attrs['ams'].each do |auto_model_attrs|
      auto_model_attrs['auto_brand_internal_id'] = auto_brand_attrs['_id']
      sync_auto_data_with_message(auto_model_attrs) do
        AutoModel.sync(auto_model_attrs['_id'], auto_model_attrs)
      end

      auto_model_attrs['asms'].each do |auto_submodel_attrs|
        auto_submodel_attrs['auto_brand_internal_id'] = auto_brand_attrs['_id']
        auto_submodel_attrs['auto_model_internal_id'] = auto_model_attrs['_id']
        # TODO: remove it
        auto_submodel_attrs['full_name'] = auto_submodel_attrs['name']
        sync_auto_data_with_message(auto_submodel_attrs) do
          AutoSubmodel.sync(auto_submodel_attrs['_id'], auto_submodel_attrs)
        end
      end
    end
  end
end

def sync_auto_data_with_message(attrs)
  model = yield
  if !model.errors.blank?
    puts "Sync #{model.model_name} data failed. " \
         "Errors: #{model.errors.full_messages.join(', ')}. " \
         "Attributes: #{model.class.extract_sync_attributes(attrs)}".colorize(:red)
  end
end
