source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# FIXME: 1.7.4 got yanked
gem 'ruby-progressbar', '1.10.1'

# as framework
gem 'rails', '~> 5.2'

# gem package to include jQuery UI assets for the Rails asset pipeline
gem 'jquery-ui-rails'

# To use jQuery's autocomplete with Rails
gem 'rails-jquery-autocomplete'

# Misc tools for fancy development
group :development, :test do
  # as our rails console
  gem 'pry-byebug'
  gem 'pry-rails'
  # to improve inspect output
  gem 'hirb'
end

# as databases
gem 'mysql2'
# for stylesheets
gem 'sass-rails', '~> 6.0'
# as the front-end framework
gem 'bootstrap-sass'
# as vector icons
gem 'font-awesome-rails'
gem 'impressionist'
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
# for file attachments
gem 'paperclip', '~> 6.1'
# as deployer
gem 'mina', '~> 0.3'
# as the app server
gem 'puma', '~> 4.3'
# as the log formater
gem 'lograge'
# for listening to file modifications
gem 'listen', '>= 3.0.5', '<= 3.2.1', group: %i[development test]

# FIXME: pin sprockets to version 3, until we upgrade.
gem 'sprockets', '~> 3'

group :test do
  # for cleaning the test DB
  gem 'database_cleaner'
  # for measuring test coverage
  gem 'coveralls', require: false
  # as style hound
  gem 'rubocop'
  gem 'rubocop-rspec'
  # Time travel in tests
  gem 'timecop'

  # Let's add real browser testing to our features (required to test AJAX)
  gem 'poltergeist'
end
