server "deploy@web1.robinclowers.com", roles: [:web, :app, :db, :sidekiq_web], key: "~/.ssh/digitalocean_ed25519"
server "deploy@utility1.robinclowers.com", roles: [:app, :sidekiq_utility], key: "~/.ssh/digitalocean_ed25519"
