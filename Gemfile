source 'https://rubygems.org'

ruby '2.3.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# fix security vulnerabilty: https://github.com/rails/rails-html-sanitizer/commit/f3ba1a839a35f2ba7f941c15e239a1cb379d56ae
gem 'rails-html-sanitizer', '~> 1.0.4'
gem 'responders', '~> 2.4.0'
gem 'rack-cors', '~> 1.0.2'

# Use postgres as the database for Active Record
gem 'pg', '~> 1.0.0'

# Use slim for templates
gem 'slim-rails', '~> 3.1.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1.6'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.2'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3.1'

gem 'sass-rails', '~> 5.0.7'
gem 'compass-rails', git: 'https://github.com/Compass/compass-rails.git'
gem 'decent_exposure', '~> 3.0.2'
gem 'rmagick'
gem 'stringex'
gem 'modernizr-rails', '~> 2.7.1'
gem 'dotenv-rails', '~> 2.5.0'
gem 'aws-sdk'
gem 'sidekiq'
gem 'sinatra', '~> 2.0.3', require: false # for sidekiq
gem 'exception_notification'
gem 'http', '~> 3.3.0'
gem 'oauth2', '~> 1.4.0'

group :development, :test do
  gem 'rspec-rails', '~> 3.7.1'
  gem 'pry'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
end

group :production do
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.3.2', require: false

# Use Omiauth for social sign in
gem 'omniauth', '~> 1.8.1'
gem 'omniauth-facebook', '~> 4.0.0'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.10.1'
gem 'capistrano3-puma', '~> 3.1.1'
gem 'capistrano-bundler', '~> 1.3.0'
gem 'capistrano-rails', '~> 1.3.1'
gem 'capistrano-sidekiq', git: 'https://github.com/RobinClowers/capistrano-sidekiq.git', branch: 'allow-different-queue-per-role-v1.0.2'

# Use Puma server
gem 'puma', '~> 3.11.3'
