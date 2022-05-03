source 'https://rubygems.org'

ruby '2.7.3'

gem 'rails', '~> 6.1.4'
gem 'responders', '~> 3.0.1'
gem 'rack-cors', '~> 1.0.5'

# Use postgres as the database for Active Record
gem 'pg', '~> 1.2.3'

# Use slim for templates
gem 'slim-rails', '~> 3.1.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1.6'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.2'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3.1'

gem 'sass-rails', '~> 5.0.7'
gem 'decent_exposure', '~> 3.0.2'
gem 'rmagick'
# For #to_url method
gem 'stringex'
gem 'dotenv-rails', '~> 2.7.6'
gem 'aws-sdk', '~> 1.53.0'
gem 'sidekiq'
gem 'sinatra', '~> 2.2.0', require: false # for sidekiq
gem 'http', '~> 4.3.0'
gem 'oauth2', '~> 1.4.0'
gem 'exiftool', '~> 1.2.1'
gem 'exiftool_vendored', '~> 10.65.0'
gem 'image_optim'
gem 'image_optim_pack'
gem 'attr_encrypted', '~> 3.1.0'
gem 'active_interaction', '~> 4.0.5'
gem "sentry-raven"

group :development, :test do
  gem 'rspec-rails', '~> 5.0.2'
  gem 'webmock', '~> 3.5.1'
  gem 'vcr', '~> 4.0.0'
  gem 'pry'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'timecop', '~> 0.9'
end

group :production do
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.16'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.9.0', require: false

gem 'devise', '~> 4.7.1'

# Use Capistrano for deployment
gem 'capistrano', '~> 3.16.0'
gem 'capistrano3-puma', '~> 5.2.0'
gem 'capistrano-bundler', '~> 2.0.1'
gem 'capistrano-rails', '~> 1.6.1'
gem 'capistrano-sidekiq', git: 'https://github.com/RobinClowers/capistrano-sidekiq.git', branch: 'allow-different-queue-per-role-v1.0.2'

# Use Puma server
gem 'puma', '~> 5.6.4'
