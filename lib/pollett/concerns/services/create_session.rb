module Pollett
  module Concerns
    module Services
      module CreateSession
        extend ActiveSupport::Concern

        include Servitore::Service

        included do
          param_reader :method
        end

        def call
          user = service.call(_params)
          user.sessions.create!
        end

        private
        def service
          @service ||= case method
          when "register" then Pollett::RegisterUser
          when "reset" then Pollett::ChangePassword
          else Pollett::AuthenticateUser
          end
        end
      end
    end
  end
end
