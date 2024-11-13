require 'mina/rails'
require 'mina/git'

set :application_name, 'hackweek'
set :domain, 'hackweek'
set :port, '22'
set :user, 'hackweek'
set :deploy_to, '/home/hackweek/hackweek'
set :repository, 'https://github.com/SUSE/hackweek.git'
set :branch, 'master'

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs, fetch(:shared_dirs, []).push('public/system', 'public/img', 'sphinx', 'storage', '.bundle', 'tmp/pids')
set :shared_files, fetch(:shared_files, []).push('config/database.yml',
                                                 'config/application.yml',
                                                 'config/secrets.yml',
                                                 'config/storage.yml',
                                                 'config/thinking_sphinx.yml',
                                                 'config/production.sphinx.conf',
                                                 'en.pak')

desc 'Deploys the current version to the server.'
task :deploy do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{sudo systemctl restart hackweek}
        command %{sudo systemctl restart hackweek-sphinx}
      end
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
