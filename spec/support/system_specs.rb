# frozen_string_literal: true

RSpec.configure do |config|
  config.include ApplicationHelper

  config.before(:all, type: :system) do
    Capybara.server = :puma, { Silent: true }
  end

  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome
  end
end

# Monkey patch for screenshots not being taken
# @see https://github.com/mattheworiordan/capybara-screenshot/issues/225
require 'action_dispatch/system_testing/test_helpers/setup_and_teardown'
::ActionDispatch::SystemTesting::TestHelpers::SetupAndTeardown.module_eval do
  def before_setup
    super
  end

  def after_teardown
    super
  end
end
