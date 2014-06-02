require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   port         - SSH port number.
#   user         - Username in the server to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'proxy-opensuse.suse.de'
set :port, '2211'
set :user, 'root'
set :deploy_to, '/srv/www/vhosts/suse.com/hackweek'
set :repository, 'https://github.com/SUSE/hackweek.git'
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
    invoke :solr_restart
    invoke :notify_errbit

    to :launch do
      queue "/etc/init.d/apache2 restart"
    end
  end
end

desc "Notifies the exception handler of the deploy."
task :notify_errbit do
  revision = `git rev-parse HEAD`.strip
  user = ENV['USER']
  queue "bundle exec rake hoptoad:deploy TO=#{rails_env} REVISION=#{revision} REPO=#{repository} USER=#{user}"
end

desc "Start solr."
task :solr_start do
  queue "cd #{deploy_to!}/#{current_path!} && sudo -u wwwrun RAILS_ENV=production bundle exec rake sunspot:solr:start"
end

desc "Stop solr."
task :solr_stop do
  queue "cd #{deploy_to!}/#{current_path!} && sudo -u wwwrun RAILS_ENV=production bundle exec rake sunspot:solr:stop"
end

desc "Restart solr."
task :solr_restart do
  invoke :solr_stop
  invoke :solr_start
end

desc "Reindex solr."
task :solr_reindex do
  queue "cd #{deploy_to!}/#{current_path!} && sudo -u wwwrun RAILS_ENV=production bundle exec rake sunspot:solr:reindex"
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

