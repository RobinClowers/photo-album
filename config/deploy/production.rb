server "deploy@web1.robinclowers.com", roles: [:web, :app, :db, :sidekiq_web]
server "deploy@utility1.robinclowers.com", roles: [:app, :sidekiq_utility]
