class UserToken < ActiveRecord::Base
  class << self
    def update_token
      token = get_token_from_api
      return if token.blank?

      name = Settings.kalading_management_api.user
      user_token = find_or_initialize_by(name: name)
      user_token.token = token
      user_token.save
    end

    def get_token
      name = Settings.kalading_management_api.user
      user_token = where(name: name).first
      user_token.token if user_token
    end

    def get_token_from_api
      name = Settings.kalading_management_api.user
      pwd = Settings.kalading_management_api.pwd

      result = KaladingManagementApi.call('post', 'users/sign_in', {phone_num: name, password: pwd})
      token = result['authentication_token']

      if token.blank?
        Rails.logger.error("Cannot get token.")
      end

      token
    end
  end
end
