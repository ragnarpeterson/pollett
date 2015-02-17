require "pollett/services/base"
require "pollett/services/authenticator"
require "pollett/services/registration"
require "pollett/services/password_changer"

module Pollett
  module Services
    class SessionCreator < Base
      def perform
        user = service.perform(params)
        user.sessions.create!
      end

      private
      def service
        @service ||= case params[:method]
        when "register" then Registration
        when "reset" then PasswordChanger
        else Authenticator
        end
      end
    end
  end
end
