require "pollett/services/base"

module Pollett
  module Services
    class Authenticator < Base
      def perform
        user_model.find_by_normalized_email(params[:email]).tap do |u|
          raise Unauthorized unless u && u.authenticate(params[:password])
        end
      end
    end
  end
end
