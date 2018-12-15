require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.credentials[:secret_key_base]
Sidekiq::Web.set :sessions, domain: ENV['COOKIE_DOMAIN']

redis_config = {
  url: ENV['REDIS_URL'],
  password: ENV['REDIS_PASSWORD'],
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

if Rails.env.test?
  require "sidekiq/testing"
  Sidekiq::Testing.fake!
end
