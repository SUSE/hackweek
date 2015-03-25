source 'https://rubygems.org'

# FIXME: 1.7.4 got yanked
gem 'ruby-progressbar', '1.7.1'

# as framework
gem 'rails', '~> 4.2'

# To speedup app startup
gem 'spring', group: [:development, :test]
gem 'spring-commands-rspec', group: [:development, :test]

# Misc tools for fancy development
group :development, :test do
  gem 'better_errors'

  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'hirb'
  gem 'quiet_assets'
end

# as databases
gem 'mysql2'
gem 'sqlite3' # Required for Travis-CI tests
# for stylesheets
gem 'sass-rails',   '~> 5.0'
# for .js.coffee assets
gem 'coffee-rails', '~> 4.1.0'
# as the front-end framework
gem 'bootstrap-sass'
# as vector icons
gem 'font-awesome-rails'
# as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# as JavaScript library
gem 'jquery-rails'
gem 'jquery-hotkeys-rails'
gem 'jquery-cookie-rails'
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
gem 'hoptoad_notifier', '~> 2.3'
# to set env variables
gem 'figaro'
# for keyboard shortcuts
gem 'mousetrap-rails'
# as search engine
gem 'thinking-sphinx'
# for seeds
gem 'factory_girl_rails', :group => [:development, :test]
gem 'faker', :group => [:development, :test]
# as test framework
gem 'rspec-rails', :group => [:development, :test]
gem 'capybara', :group => [:development, :test]
# for file attachments
gem 'paperclip', '~> 4.1'

group :test do
  # for cleaning the test DB
  gem 'database_cleaner'
  # for measuring test coverage
  gem 'coveralls', require: false
  # as style hound
  gem 'rubocop'
  # as interactive debugger in error pages
  gem 'web-console', '~> 2.0'

  # Time travel in tests
  gem 'timecop'

  # Used in Travis-CI reporting
  gem "codeclimate-test-reporter", require: false
end
