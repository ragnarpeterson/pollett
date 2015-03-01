module Pollett
  class AuthenticateUser
    include Servitore::Service

    param_reader :email, :password

    def call
      Pollett.config.user_model.find_by_normalized_email(email).tap do |u|
        raise Unauthorized unless u && u.authenticate(password)
      end
    end
  end
end
