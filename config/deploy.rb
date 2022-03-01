require 'mina/rails'
require 'mina/git'

set :application_name, 'hackweek'
set :domain, 'dale.infra.opensuse.org'
set :port, '22'
set :user, 'hackweek'
set :deploy_to, '/home/hackweek/hackweek'
set :repository, 'git://github.com/SUSE/hackweek.git'
set :branch, 'master'

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs, fetch(:shared_dirs, []).push('public/system', 'sphinx', 'storage')
set :shared_files, fetch(:shared_files, []).push('config/database.yml',
                                                 'config/application.yml',
                                                 'config/secrets.yml',
                                                 'config/storage.yml',
                                                 'config/thinking_sphinx.yml',
                                                 'config/production.sphinx.conf',
                                                 'en.pak')

task :'bundle:config' do
  comment 'Configuring bundle'
  command 'bundle config build.nokogiri --use-system-libraries'
  command 'bundle config set --local path "vendor/bundle"'
end

desc 'Deploys the current version to the server.'
task :deploy do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:config'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
