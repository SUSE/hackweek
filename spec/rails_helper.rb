require 'simplecov'
require 'webdrivers'

if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  Coveralls.wear!('rails')
else
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # ThinkingSphinx uses DB directly, so transactions are useless there
  config.use_transactional_fixtures = false

  # mix in different behaviours to your tests based on their file location,
  # for example enabling you to call `get` and `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  Capybara.register_driver :chrome_headless do |app|
    options = ::Selenium::WebDriver::Chrome::Options.new
    options.args << '--window-size=1920x1080'
    options.args << '--headless'
    options.args << '--no-sandbox'
    options.args << '--disable-gpu'
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :chrome_headless

  # Setting up DB cleaning to maintain empty rows
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :truncation
    FileUtils.rm_rf(File.join(Capybara.save_path, '.'), secure: true)
  end

  # Search requires complicated setup (and also mostly tests external libraries and tools, not our code)
  # So we're omitting it from default runs
  config.filter_run_excluding search: true

  config.before(:each) do |example|
    if example.metadata[:search]
      # Ensure sphinx directories exist for the test environment
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start
    else
      ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] = false
    end

    DatabaseCleaner.start
  end

  config.after(:each) do |example|
    if example.metadata[:search]
      ThinkingSphinx::Test.stop
      ThinkingSphinx::Test.clear
    end

    DatabaseCleaner.clean
  end

  # Automatically save the page a test fails
  config.after(:each, type: :feature) do
    if RSpec.current_example.exception.present?
      example_filename = RSpec.current_example.full_description
      example_filename = example_filename.gsub(/[^0-9A-Za-z_]/, '_')
      example_filename = File.expand_path(example_filename, Capybara.save_path)
      save_page("#{example_filename}.html")
      save_screenshot("#{example_filename}.png")
    end
  end

  # Include helpers and connect them to specific types of tests
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include LoginMacros, type: :feature
  # config.include Flash, type: :feature
  config.include SphinxHelpers, search: true

  # As we start from scratch in September 2014, let's forbid the old :should syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Enable colored output
  config.tty = true
  config.color = true
end
