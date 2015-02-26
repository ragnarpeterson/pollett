require "rspec/rails"
require "pollett/testing/request_helper"

RSpec.configure do |config|
  config.include Pollett::Testing::RequestHelper, type: :request
end
