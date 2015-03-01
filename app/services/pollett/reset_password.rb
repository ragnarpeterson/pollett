module Pollett
  class ResetPassword
    include Servitore::Service

    param_reader :email

    def call
      Pollett.config.user_model.find_by_normalized_email(email).tap do |user|
        deliver_email(user) if user
      end
    end

    private
    def deliver_email(user)
      user.update!(reset_token: Pollett.generate_token)
      Mailer.reset(user).deliver_later
    end
  end
end
