require "pollett/services/base"

module Pollett
  module Services
    class Registration < Base
      def perform
        user_model.create!(safe_params).tap do |u|
          send_welcome(u) if Pollett.config.send_welcome_email
        end
      end

      private
      def safe_params
        permitted = Pollett.config.whitelist | [:email, :password]
        params.permit(*permitted)
      end

      def send_welcome(user)
        Mailer.welcome(user).deliver_later
      end
    end
  end
end
