ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require "factory_girl_rails"
require "pollett/rspec"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include EmailHelper

  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  config.order = :random

  config.before(:each) { reset_email }
end
