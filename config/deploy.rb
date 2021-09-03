# config valid only for Capistrano 3.1

set :application, 'mdl'
set :repo_url, 'git@github.com:UMNLibraries/mdl_search.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :default_environment, {
  'PATH' => "/swadm/bin/ruby:$PATH"
}

append :linked_dirs, "log"

set :rails_env, "production"

set :passenger_restart_with_touch, true

# Restart all sidekiq instances so they can pick up the new code
namespace :deploy do
  task :prep_uv do
    on roles(:all) do |host|
      within release_path do
        execute './prep_uv.sh'
      end
    end
  end
  ###
  # Called by capistrano-sidekiq
  task :restart_sidekiq do
    on roles(:all) do |host|
      (0..2).map do |pid|
        execute "sudo systemctl restart sidekiq-#{pid}"
      end
    end
  end
end

after 'deploy:updated', 'deploy:prep_uv'
