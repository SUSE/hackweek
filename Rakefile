#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'sunspot/solr/tasks'

Hackweek::Application.load_tasks

gem 'single_test'
require 'single_test/tasks'
