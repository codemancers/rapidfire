$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rapidfire/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rapidfire"
  s.version     = Rapidfire::VERSION
  s.authors     = ["Yuva Kumar"]
  s.email       = ["yuva@codemancers.com"]
  s.homepage    = "https://github.com/code-mancers/rapidfire"
  s.summary     = "Surveys made easy."
  s.description = "One stop solution for all survey related requirements! Its tad easy!."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails",    ">= 3.2.13"
  s.add_dependency "active_model_serializers", "~> 0.8.1"

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
