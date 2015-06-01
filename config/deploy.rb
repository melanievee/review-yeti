require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina_sidekiq/tasks'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)
require 'mina/unicorn'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '192.241.226.110'
set :deploy_to, '/home/deployer/review-yeti'
set :repository, 'git@bitbucket.org:alpinepipeline/review-yeti.git'
set :branch, 'master'
set :user, 'deployer'
set :forward_agent, false # was true in tutorial, kevin turned off
# set :port, '22' # Kevin commented out
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"


# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml']


# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  queue %{
    echo "-----> Loading environment"
    #{echo_cmd %[source ~/.bashrc]}
    #{echo_cmd %[source ~/.prodrc]}
}

  invoke :'rvm:use[ruby-2.0.0]'
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
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

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]
end

namespace :sidekiq_upstart do
  desc 'Start the sidekiq workers via Upstart'
  task :start do
    sudo 'start sidekiq index=0'
  end
 
  desc 'Stop the sidekiq workers via Upstart'
  task :stop do
    sudo 'stop sidekiq index=0 || true'
  end
 
  desc 'Restart the sidekiq workers via Upstart'
  task :restart do
    sudo 'stop sidekiq index=0 || true'
    sudo 'start sidekiq index=0'
  end
 
  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet do
    pid_file       = "#{deploy_path}/shared/pids/sidekiq.pid"
    sidekiqctl_cmd = "bundle exec sidekiqctl"
    run "if [ -d #{deploy_path} ] && [ -f #{pid_file} ] && kill -0 `cat #{pid_file}`> /dev/null 2>&1; then cd #{deploy_path} && #{sidekiqctl_cmd} quiet #{pid_file} ; else echo 'Sidekiq is not running'; fi"
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do

    # stop accepting new workers
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'sidekiq:restart' 
      invoke :'unicorn:restart'
    end
  end
end