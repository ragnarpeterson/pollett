module Pollett
  module Concerns
    module Services
      module RegisterUser
        extend ActiveSupport::Concern

        include Servitore::Service

        PERMITTED = [:name, :email, :password]

        def call
          Pollett.config.user_model.create!(safe_params).tap do |user|
            deliver_email(user) if Pollett.config.send_welcome_email
          end
        end

        private
        def safe_params
          permitted = Pollett.config.whitelist | PERMITTED
          _params.permit(*permitted)
        end

        def deliver_email(user)
          Mailer.welcome(user).deliver_later
        end
      end
    end
  end
end
