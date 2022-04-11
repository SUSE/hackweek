source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# as framework
gem 'rails', '~> 7.0.1'
# as asset pipeline
gem 'sprockets-rails'
# as the app server
gem 'puma'

group :development, :test do
  # as our rails console
  gem 'pry-byebug'
  gem 'pry-rails'
  # to improve inspect output
  gem 'hirb'
end

group :test do
  # for cleaning the test DB
  gem 'database_cleaner'
  # for measuring test coverage
  gem 'coveralls', require: false
  # as style hound
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  # Time travel in tests
  gem 'timecop'

  # Let's add real browser testing to our features (required to test AJAX)
  gem 'poltergeist'
end

# as databases
gem 'mysql2'
# for stylesheets
gem 'sass-rails'
# as the front-end framework
gem 'bootstrap-sass'
# as vector icons
gem 'font-awesome-sass'
# as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# as JavaScript library
gem 'jquery-atwho-rails'
gem 'jquery-hotkeys-rails'
gem 'jquery-rails'
gem 'js_cookie_rails'
# as templating language
gem 'haml-rails'
# as authentification framework
gem 'devise'
gem 'devise_ichain_authenticatable'
# as authorization framework
gem 'cancancan'
# for spam detection
gem 'rakismet'
# for user avatars
gem 'gravtastic'
# for markdown rendering
gem 'redcarpet'
# for token input
gem 'selectize-rails'
# as state machine
gem 'aasm'
# as exception notifier
gem 'sentry-rails'
gem 'sentry-ruby'
# to set env variables
gem 'figaro'
# for keyboard shortcuts
gem 'mousetrap-rails'
# as search engine
gem 'thinking-sphinx'
# for pagination
gem 'kaminari'
# for slugs
gem 'stringex'
# for seeds
gem 'factory_bot_rails', group: %i[development test]
gem 'faker', group: %i[development test]
# as test framework
gem 'capybara', group: %i[development test]
gem 'rails-controller-testing', group: %i[development test]
gem 'rspec-rails', group: %i[development test]
# as deployer
gem 'mina'
# as the log formater
gem 'lograge'
# for listening to file modifications
gem 'listen'
