module V2
  module Helpers

    def json_wrapper(msg = '', code = 0, data)
      { msg: msg, code: code, data: data }
    end

    alias :wrapper :json_wrapper

    def template_path(path)
      env['api.tilt.template'] = "v2/views/#{path}"
    end

    def current_resource
      @current_resource ||= get_resource!(Grape::Request.new(env).headers)
    end

    def authenticate!
      if current_resource.nil?
        raise AuthenticationError
      end
    end

    private

    def get_resource!(headers)
      source = headers['X-Source'].to_s.downcase
      token = headers['X-Token'].to_s

      case source
      when 'engineer'
        # Engineer app should encode payload like this:
        #   payload = { id: '...' }
        #   token = JWT.encode(payload, secret, 'HS256')
        # Then set headers:
        #   headers['X-Source'] = 'engineer'
        #   headers['X-Token'] = token
        payload, _ = JWT.decode(token, Settings.api.secret)
        user = User.where(internal_id: payload['id']).first
        resource = user if user.has_role?('engineer')
      when 'customer'
        resource = Customer.find_by(token: token)
      end
      resource
    rescue JWT::DecodeError
      raise AuthenticationError
    end
  end

#######
  class Error < Grape::Exceptions::Base
    attr :code, :text

    def initialize(opts={})
      @code    = opts[:code]   || ''
      @text    = opts[:text]   || ''
      @status  = opts[:status] || ''

      @message = {msg: @text, code: @code}
    end
  end

  class AuthorizationError < Error
    def initialize
      super code: 1001, text: 'Authorization failed', status: 403
    end
  end

  class PermissionDeniedError < Error
    def initialize
      super code: 1002, text: 'Permission denied', status: 403
    end
  end

  class TokenExpiredError < Error
    def initialize
      super code: 1003, text: 'Token expired', status: 403
    end
  end

  class AuthenticationError < Error
    def initialize
      super code: 1004, text: 'Authentication failed', status: 401
    end
  end


  class ResourceNotFoundError < Error
    def initialize
      super code: 2001, text: 'resource not found', status: 404
    end
  end
end

