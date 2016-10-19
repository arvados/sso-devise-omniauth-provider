require 'rails'

module OmniAuth
  module Strategies
    class LDAP
      def request_phase
        OmniAuth::LDAP::Adaptor.validate @options
        redirect "/users/ldap_sign_in"
      end

      def fail!(message_key, exception = nil)
        if exception
          log :error, "Authentication failure! #{message_key}: #{exception.class}, #{exception.message}"
        else
          log :error, "Authentication failure! #{message_key} encountered."
        end
        redirect "/users/ldap_sign_in?alert=1"
      end

    end
  end
end
