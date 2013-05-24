$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rapidfire/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rapidfire"
  s.version     = Rapidfire::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rapidfire."
  s.description = "TODO: Description of Rapidfire."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails",        "~> 3.2.13"
  s.add_dependency "jquery-rails", "~> 2.2.1"
  s.add_dependency "coffee-rails", "~> 3.2.1"
  s.add_dependency "uglifier",     ">= 1.0.3"
  s.add_dependency "strong_parameters", "~> 0.2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'quiet_assets'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'capybara', '2.0.3'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'launchy'
end
