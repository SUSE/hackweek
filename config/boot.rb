ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
# FIXME: This is fixed in 7.1 (see https://github.com/rails/rails/issues/54260#issuecomment-2594962172)
# Until we upgrade to 7.1 we need this hack in place
require 'logger'
