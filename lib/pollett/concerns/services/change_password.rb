module Pollett
  module Concerns
    module Services
      module ChangePassword
        extend ActiveSupport::Concern

        include Servitore::Service

        included do
          param_reader :token, :password
        end

        def call
          Pollett.config.user_model.find_by!(reset_token: token).tap do |u|
            u.update!(password: password, reset_token: nil)
          end
        end
      end
    end
  end
end
