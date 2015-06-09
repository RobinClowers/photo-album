require 'dotenv'
Dotenv.load

server 'root@107.170.241.16', roles: [:web, :app, :db, :sidekiq_web]
server "deploy@#{ENV['UTILITY1_HOSTNAME']}", roles: [:app, :sidekiq_utility]
