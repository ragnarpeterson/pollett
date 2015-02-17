require "pollett/configuration"
require "pollett/controller"
require "pollett/user"
require "pollett/engine"

module Pollett
  Unauthorized = Class.new(StandardError)

  TOKEN_LENGTH = 32

  def self.generate_token(length = TOKEN_LENGTH)
    SecureRandom.urlsafe_base64(length)
  end

  def self.reset_url(token)
    config.reset_url.call(token)
  end
end
