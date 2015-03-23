module Pollett
  module Concerns
    module Services
      module AuthenticateUser
        extend ActiveSupport::Concern

        include Servitore::Service

        included do
          param_reader :email, :password
        end

        def call
          Pollett.config.user_model.find_by_normalized_email(email).tap do |u|
            raise Unauthorized unless u && u.authenticate(password)
          end
        end
      end
    end
  end
end
