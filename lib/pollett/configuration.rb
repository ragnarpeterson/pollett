module Pollett
  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end

  class Configuration
    attr_accessor :user_model,
                  :minimum_password_length,
                  :send_welcome_email,
                  :parent_mailer,
                  :from_email,
                  :reset_url,
                  :whitelist,
                  :timeout

    def initialize
      @user_model = ::User
      @minimum_password_length = 8
      @send_welcome_email = true
      @parent_mailer = ::ApplicationMailer
      @reset_url = ->(token) { "https://example.com/#{token}/reset" }
      @whitelist = []
      @timeout = 2.weeks
    end

    def user_model_name
      "::#{user_model.name}"
    end
  end
end
