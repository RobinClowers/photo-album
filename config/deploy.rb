# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'photo-album'
set :repo_url, 'git@github.com:RobinClowers/photo-album.git'
set :puma_role, :web
set :assets_roles, [:web]

set :default_env, {
  'PATH' => '/opt/rubies/ruby-2.1.2/bin:$PATH',
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

set :linked_dirs, %w{log tmp}
set :linked_files, %w{.env}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5