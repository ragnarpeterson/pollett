require "pollett/services/base"

module Pollett
  module Services
    class PasswordResetter < Base
      def perform
        user_model.find_by_normalized_email(params[:email]).tap do |u|
          send_reset(u) if u
        end
      end

      private
      def send_reset(user)
        user.update!(reset_token: Pollett.generate_token)
        Mailer.reset(user).deliver_later
      end
    end
  end
end
