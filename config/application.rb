require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PhotoAlbum
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths << Rails.root.join("app", "features", "album")
    config.autoload_paths << Rails.root.join("app", "features", "photo")
    config.offline_dev = ENV['OFFLINE_DEV'] == 'true'
    config.bucket_name = "robin-photos"
    config.base_photo_url = "//s3.amazonaws.com/#{config.bucket_name}/"
    config.base_secure_photo_url = "https://s3.amazonaws.com/#{config.bucket_name}/"
    config.action_mailer.default_url_options = {
      host: 'photos.robinclowers.com'
    }

    Slim::Engine.options[:pretty] = false
  end
end
