require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# The hostname to SSH to
set :domain, 'proxy-opensuse.suse.de'
# SSH port number
set :port, '2211'
# Username in the server to SSH to
set :user, 'root'
# Path to deploy into
set :deploy_to, '/srv/www/vhosts/suse.com/hackweek'
# Git repo to clone from
set :repository, 'https://github.com/SUSE/hackweek.git'
# Branch name to deploy
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/application.yml', 'config/secrets.yml', 'log', 'public/gallery', 'solr/data', 'solr/pids']

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/application.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/application.yml'."]

  queue! %[mkdir -p "#{deploy_to}/shared/solr"]
  queue! %[chmod g+rx,u+rws "#{deploy_to}/shared/solr"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :notify_errbit

    to :launch do
      queue "/etc/init.d/apache2 restart"
      invoke :solr_restart
    end
  end
end

desc "Notifies the exception handler of the deploy."
task :notify_errbit do
  revision = `git rev-parse HEAD`.strip
  user = ENV['USER']
  queue "RAILS_ENV=#{rails_env} bundle exec rake hoptoad:deploy TO=#{rails_env} REVISION=#{revision} REPO=#{repository} USER=#{user}"
end

desc "Restart solr."
task :solr_restart do
  queue "cd #{deploy_to!}/#{current_path!} && sudo -u wwwrun RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:force_restart"
end

desc "Reindex solr."
task :solr_reindex do
  queue "cd #{deploy_to!}/#{current_path!} && sudo -u wwwrun RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
end
