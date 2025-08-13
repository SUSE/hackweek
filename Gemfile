def next?
  File.basename(__FILE__) == 'Gemfile.next'
end
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# as framework
if next?
  gem 'rails', '~> 7.2'
else
  gem 'rails', '~> 7.0.1'
end
# as asset pipeline
gem 'sprockets-rails'
# as the app server
gem 'puma'

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
# for user avatars
gem 'gravtastic'
# for markdown rendering
gem 'redcarpet'
# for code block syntax highlighting
gem 'rouge'
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
# as deployer
gem 'mina'
# as the log formater
gem 'lograge'
# for listening to file modifications
gem 'listen'
# FIXME: activesupport-7.0.8.7 expects those to be in the standard library, which they aren't anymore since 3.4.0
gem 'drb'
gem 'mutex_m'

# for testing next rails versions
gem 'next_rails', group: %i[development test]
# for seeds
gem 'factory_bot_rails', group: %i[development test]
gem 'faker', group: %i[development test]
# as test framework
gem 'capybara', group: %i[development test]
gem 'rails-controller-testing', group: %i[development test]
gem 'rspec-rails', group: %i[development test]
# as our rails console
gem 'pry-byebug', group: %i[development test]
gem 'pry-rails', group: %i[development test]
# to improve inspect output
gem 'hirb', group: %i[development test]

# for cleaning the test DB
gem 'database_cleaner', group: :test
# for measuring test coverage
gem 'coveralls', require: false, group: :test
# as style hound
gem 'rubocop', group: :test
gem 'rubocop-capybara', group: :test
gem 'rubocop-factory_bot', group: :test
gem 'rubocop-rails', group: :test
gem 'rubocop-rspec', group: :test
# for time travel in tests
gem 'timecop', group: :test
# for feature tests
gem 'webdrivers', group: :test
