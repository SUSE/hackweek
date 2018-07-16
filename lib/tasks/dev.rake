# Don't add any includes that aren't in the Ruby std-lib here,
# If you do, dev:bootstrap will fail on bundle:install

require 'find'

class String
  def red
    "\e[0;31;49m#{self}\e[0m"
  end

  def green
    "\e[0;32;49m#{self}\e[0m"
  end
end

namespace :dev do
  file_task_names = []

  %w(application database secrets).each do |example_base|
    config_file = File.join('config', "#{example_base}.yml")
    config_example = File.join('config', "#{example_base}.yml.example")
    t = Rake::FileTask.define_task(config_file => config_example) do |task|
      if File.exists?(task.name)
        puts ">>> Skipping #{task.prerequisites.first} -> #{task.name}, please examine and merge if needed."
      else
        cp task.prerequisites.first, task.name
      end
    end
    file_task_names << t.name
  end

  desc "copy example config files into place if they aren't already"
  task copy_sample_configs: file_task_names

  desc 'install gems using Bundler'
  task :bundle_install do
    sh 'bundle install'
  end

  desc 'check for searchd'
  task :require_searchd do
    found = false

    ENV['PATH'].split(':').each do |path|
      next unless File.exists?(path)
      found = !Find.find(path).select {|f| f.match(/\bsearchd$/) && File.executable?(f)}.empty?
      break if found
    end

    fail "Can't find searchd for Sphinx. Please install or add to PATH.".red unless found
  end

  desc 'bootstrap development environment'
  task bootstrap: %w(copy_sample_configs bundle_install db:create db:setup db:seed require_searchd ts:rebuild) do
    puts "\n\nCongrats! You should be all set.".green
    puts "\nHappy Hacking!".green
  end
end
