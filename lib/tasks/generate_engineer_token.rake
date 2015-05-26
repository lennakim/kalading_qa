namespace :qa do
  desc "Generate a api token of engineer app, usage: rake qa:generate_engineer_token id=engineer_internal_id, if id is omitted the first engineer will be found"
  task generate_engineer_token: :environment do
    if Rails.env.production?
      puts "Don't do this in production".colorize(:red)
      next
    end

    id = ENV['id']
    if id.blank?
      puts "You didn't specify an engineer internal id, so we found the first one."
      engineer = User.engineers.first
    else
      engineer = User.engineers.where(internal_id: id).first
    end

    if engineer.nil?
      puts "Can't find any user as engineer.".colorize(:red)
    else
      puts 'Token: ' + JWT.encode({id: engineer.internal_id}, Settings.api.secret, 'HS256')
    end
  end
end
