source 'https://rubygems.org'

ruby '2.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.2'

# Use postgres as the database for Active Record
gem 'pg'

# Use slim for templates
gem 'slim-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
gem 'decent_exposure'
gem 'rmagick'
gem 'stringex'
gem 'modernizr-rails'
gem 'dotenv', '~> 0.11.1'
gem 'dotenv-rails'
gem 'dotenv-deployment'
gem 'aws-sdk'
gem 'sidekiq'
gem 'sinatra', require: false # for sidekiq
gem 'exception_notification'

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'pry'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.1'

# Use Omiauth for social sign in
gem 'omniauth', '~>1.2.1'
gem 'omniauth-facebook', '~> 2.0.0'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.4.0'
gem 'capistrano3-puma', '~> 0.5.1'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-sidekiq', git: 'https://github.com/RobinClowers/capistrano-sidekiq.git', branch: 'allow-different-queue-per-role'

# Use Puma server
gem 'puma', '~> 2.8.1'
