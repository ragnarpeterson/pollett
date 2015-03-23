module Pollett
  module Concerns
    module Mailers
      module Mailer
        extend ActiveSupport::Concern

        included do
          default from: Pollett.config.from_email if Pollett.config.from_email
        end

        def welcome(user)
          @user = user
          mail(to: user.email)
        end

        def reset(user)
          @user = user
          @url = Pollett.reset_url(user.reset_token)
          mail(to: user.email)
        end
      end
    end
  end
end