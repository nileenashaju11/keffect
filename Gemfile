# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'activestorage-validator'
gem 'awesome_rails_console'
gem 'aws-sdk-s3', require: false
gem 'basecrm', '~> 1.3.8'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'devise'
gem 'faraday'
gem 'faraday_middleware'
gem 'figaro'
gem 'google-api-client'
gem 'image_processing', '~> 1.2'
gem 'jbuilder', '~> 2.5'
gem 'pg'
gem 'puma', '~> 4.3.0'
gem 'rack-cors'
gem 'rails', '~> 6.0.0'
gem 'redis-rack-cache'
gem 'rollbar'
gem 'sass-rails', '~> 6.0.0'
gem 'sidekiq'
gem 'sidekiq-status'
gem 'turbolinks', '~> 5'
gem 'twilio-ruby', '~> 5.34.1'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'factory_bot_rails' # Fake object generation
  gem 'faker' # Fake test data
  gem 'hirb'
  gem 'hirb-unicode-steakknife', require: 'hirb-unicode'
  gem 'pry', '~> 0.12.2'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'rubocop', require: false
  gem 'rubocop-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
end
