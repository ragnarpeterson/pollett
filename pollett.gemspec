$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pollett/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pollett"
  s.version     = Pollett::VERSION
  s.authors     = ["Jason Kriss"]
  s.email       = ["jasonkriss@gmail.com"]
  s.homepage    = "https://github.com/jasonkriss/pollett"
  s.summary     = %q{Token-based authentication for your Rails API.}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "active_model_serializers", "0.9.3"
  s.add_dependency "bcrypt"
  s.add_dependency "email_validator"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
