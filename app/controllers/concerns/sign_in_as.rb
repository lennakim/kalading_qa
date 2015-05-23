module Concerns
  module SignInAs
    extend ActiveSupport::Concern

    module Application
      def admin_sign_in_as_user?
        session[:admin_sign_in_as].to_s == 'true'
      end

      def clean_sign_in_as
        session[:admin_sign_in_as] = nil if session[:admin_sign_in_as].present?
      end
    end

    module Admins
      def set_sign_in_as
        session[:admin_sign_in_as] = 'true'
      end
    end
  end
end
