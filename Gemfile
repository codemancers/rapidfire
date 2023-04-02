source 'https://rubygems.org'

gemspec

gem 'rails', "~> #{ENV['RAILS_VERSION']}"
gem 'pg'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13.0'
  gem 'selenium-webdriver'
  gem 'pry-rails'
end
