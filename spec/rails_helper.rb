require 'simplecov'

if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  Coveralls.wear!('rails')
else
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'sunspot_test/rspec'

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
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # mix in different behaviours to your tests based on their file location,
  # for example enabling you to call `get` and `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Setting up DB cleaning to maintain empty rows
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Include helpers and connect them to specific types of tests
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include LoginMacros, type: :feature
  #config.include Flash, type: :feature

  # As we start from scratch in September 2014, let's forbid the old :should syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
