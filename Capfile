# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'
require "capistrano/scm/git"
require 'capistrano/puma'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/sidekiq'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
