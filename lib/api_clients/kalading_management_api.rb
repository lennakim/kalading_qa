module KaladingManagementApi
  extend self

  def call(method, api_name, params = {})
    url = URI.join("#{Settings.kalading_management_api_uri}/#{api_name}/", params.delete(:id)).to_s.chomp('/') + '.json'

    response = Timeout::timeout(10) {
      method.to_s == 'get' ?
        RestClient.get(url, params: params, content_type: :json, accept: :json) :
        RestClient.send(method, url, params, content_type: :json, accept: :json)
    }

    JSON.parse(response)
  rescue Exception => e
    Rails.logger.error("Calling the API #{url} with parameters #{params} failed.\n" \
                       "#{e.hint}")
    raise e
  end

end
