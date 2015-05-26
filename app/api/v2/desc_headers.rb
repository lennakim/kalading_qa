module V2
  module DescHeaders
    extend self

    TOKEN_DESC = {
      engineer: 'JWT encode后的token值',
      customer: 'user token'
    }

    def authentication_headers(options = {})
      source = options[:source].try(:to_sym)
      source_desc = source || 'engineer, customer'
      token_desc = source.present? ? TOKEN_DESC[source] : TOKEN_DESC.map{|k,v| "#{k}: #{v}"}.join('. ')

      {
        'X-Source' => {
          description: source_desc,
          required: true,
          default: source
        },
        'X-Token' => {
          description: token_desc,
          required: true
        }
      }
    end
  end
end
