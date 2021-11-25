# frozen_string_literal: true

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.include Devise::Test::IntegrationHelpers
end
