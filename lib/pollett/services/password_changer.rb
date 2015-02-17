require "pollett/services/base"

module Pollett
  module Services
    class PasswordChanger < Base
      def perform
        user_model.find_by!(reset_token: params[:token]).tap do |u|
          u.update!(password: params[:password], reset_token: nil)
        end
      end
    end
  end
end
