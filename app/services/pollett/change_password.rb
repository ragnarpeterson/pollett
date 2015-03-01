module Pollett
  class ChangePassword
    include Servitore::Service

    param_reader :token, :password

    def call
      Pollett.config.user_model.find_by!(reset_token: token).tap do |u|
        u.update!(password: password, reset_token: nil)
      end
    end
  end
end
