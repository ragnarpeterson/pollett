module Pollett
  module Concerns
    module Services
      module CreateSession
        extend ActiveSupport::Concern

        include Servitore::Service

        def call
          user = service.call(_params)
          user.sessions.create!
        end

        private
        def service
          @service ||= if _params.key?(:name)
            Pollett::RegisterUser
          elsif _params.key?(:token)
            Pollett::ChangePassword
          else
            Pollett::AuthenticateUser
          end
        end
      end
    end
  end
end
