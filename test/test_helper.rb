ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  class Stubber

    def self.fake_authentication user
      AccountController.send :alias_method, :orig_auth_hash, :auth_hash

      AccountController.send :define_method, :auth_hash do
        {
          :uid => "fake:123",
          :info => { :name => user.name, :email => user.email }
        }
      end
    end

    def self.unfake_authentication
        AccountController.send :alias_method, :auth_hash, :orig_auth_hash
    end

  end

  def assume_user_logged_in user
    Stubber.fake_authentication user
    visit "/account/callback"
    Stubber.unfake_authentication
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def login user
    @request.session[:user_id] = user.id
    @controller.instance_variable_set('current_user', user)
  end

end
