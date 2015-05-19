class UserToken < ActiveRecord::Base
  class << self
    def update_token
      name = Settings.kalading_management_api.user
      token = get_token_from_api

      user_token = where(name: name).first || new(name: name)
      user_token.token = token
      user_token.save
    end

    def get_token
      name = Settings.kalading_management_api.user
      user_token = where(name: name).first

      if user_token.blank?
        update_token
        user_token = where(name: name).first
      end

      user_token.token
    end

    def get_token_from_api
      name = Settings.kalading_management_api.user
      pwd = Settings.kalading_management_api.pwd

      result = KaladingManagementApi.call('post', 'users/sign_in', {phone_num: name, password: pwd})
      result['authentication_token']
    end
  end
end
