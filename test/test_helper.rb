require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
Capybara.default_driver = :webkit
require 'sunspot_test/test_unit'

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  self.use_transactional_fixtures = false

  def login_user(user)
    visit new_user_ichain_session_path
    within('#session') do
      fill_in 'Username', with: user.name
      fill_in 'Email', with: user.email
      click_button 'Sign In'
    end
  end

  def logout_user(hard=false)
    if hard
      visit projects_path
    end
    click_link("user-dropdown")
    click_link('Log out')
  end

  setup do
  end

  teardown do
    dirpath = Rails.root.join("tmp", "capybara")
    htmlpath = dirpath.join(self.__name__ + ".html")
    if !passed?
      Dir.mkdir(dirpath) unless Dir.exists? dirpath
      save_page(htmlpath)
    elsif File.exists?(htmlpath)
      File.unlink(htmlpath)
    end
    Capybara.reset_sessions!
  end

end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
end

class ActionController::TestCase
  include Devise::TestHelpers
end
