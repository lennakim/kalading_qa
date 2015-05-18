module KaladingManagementApi
  extend self

  def call(method, api_name, params = {})
    raise "Please fill out kalading_management_api in config/settings.yml" if Settings.kalading_management_api.blank?
    params.merge!(auth_token: UserToken.get_token)
    url = URI.join("#{Settings.kalading_management_api.uri}/#{api_name}/", params.delete(:id).to_s).to_s.chomp('/') + '.json'

    log_message = "Calling the API [#{method.to_s.capitalize}]#{url} with parameters #{params.except(:password, :auth_token)}"

    response = Timeout::timeout(10) {
      method.to_s == 'get' ?
        RestClient.get(url, params: params, content_type: :json, accept: :json) :
        RestClient.send(method, url, params, content_type: :json, accept: :json)
    }
    Rails.logger.info(log_message)

    JSON.parse(response)
  rescue Exception => e
    Rails.logger.error("#{log_message} failed.\n" \
                       "#{e.hint}".colorize(:red))
    raise e
  end

end
