require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# The hostname to SSH to
set :domain, 'proxy-opensuse.suse.de'
# SSH port number
set :port, '2224'
# Username in the server to SSH to
set :user, 'hwrun'
# Path to deploy into
set :deploy_to, '/home/hwrun/hackweek'
# Git repo to clone from
set :repository, 'git://github.com/SUSE/hackweek.git'
# Branch name to deploy
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/application.yml', 'config/secrets.yml', 'config/storage.yml', 'config/thinking_sphinx.yml', 'config/production.sphinx.conf', 'log', 'tmp', 'public/gallery', 'en.pak', 'sphinx', 'public/system']

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[mkdir -p "#{deploy_to}/shared/sphinx/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/application.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/application.yml'."]

  queue! %[wget 'http://sphinxsearch.com/files/dicts/en.pak' -O "#{deploy_to}/shared/en.pak"]
  queue! %[zypper --non-interactive ar -f https://download.opensuse.org/repositories/openSUSE:/infrastructure:/hackweek/SLE_15/openSUSE:infrastructure:hackweek.repo]
  queue! %[zypper --non-interactive in hackweek-service]
  queue! %[systemctl enable hackweek]
  queue! %[systemctl enable searchd]
  queue! %[chown hwrun:hwrun -R "#{deploy_to}/shared"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :chown
    invoke :sphinx_restart

    to :launch do
      queue "sudo systemctl restart hackweek"
      queue "sudo systemctl restart apache2"
    end
  end
end

task :chown do
  queue "cd #{deploy_to!}/#{current_path!} && chown hwrun:hwrun -R ."
end

desc "Restart Sphinx."
task :sphinx_restart do
  queue "cd #{deploy_to!}/#{current_path!} && RAILS_ENV=#{rails_env} bundle exec rake ts:rebuild"
end
