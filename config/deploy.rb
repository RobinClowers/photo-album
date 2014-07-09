# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'photo-album'
set :repo_url, 'git@github.com:RobinClowers/photo-album.git'
set :puma_role, :app
set :puma_env, -> { fetch(:rack_env, fetch(:rails_env, fetch(:stage))) }
# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
set :puma_threads, [0, 16]
set :puma_workers, 0
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, -> { File.join(shared_path, 'tmp', 'pids', 'puma.state') }
set :puma_pid, -> { File.join(shared_path, 'tmp', 'pids', 'puma.pid') }
set :puma_bind, -> { File.join('unix://', shared_path, 'tmp', 'sockets', 'puma.sock') }
set :puma_conf, -> { File.join(shared_path, 'puma.rb') }
set :puma_access_log, -> { File.join(shared_path, 'log', 'puma_error.log') }
set :puma_error_log, -> { File.join(shared_path, 'log', 'puma_access.log') }
set :puma_init_active_record, false
set :puma_preload_app, true

set :default_env, {
  'PATH' => '/opt/rubies/ruby-2.1.1/bin:$PATH',
}

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/srv/photo_album'

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
