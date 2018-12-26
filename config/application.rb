require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PhotoAlbum
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join("app", "features", "album")
    config.autoload_paths << Rails.root.join("app", "features", "photo")
    config.offline_dev = ENV['OFFLINE_DEV'] == 'true'
    config.bucket_name = "robin-photos"
    config.base_photo_url = "//s3.amazonaws.com/#{config.bucket_name}/"
    config.base_secure_photo_url = "https://s3.amazonaws.com/#{config.bucket_name}/"
    config.action_controller.forgery_protection_origin_check = false
    config.action_mailer.default_url_options = {
      host: ENV["FRONT_END_DOMAIN"],
    }

    Slim::Engine.options[:pretty] = false

    # Load defaults from config/*.env in config
    Dotenv.load *Dir.glob(Rails.root.join("*.env"), File::FNM_DOTMATCH)

    # Override any existing variables if an environment-specific file exists
    Dotenv.overload *Dir.glob(Rails.root.join(".env.#{Rails.env}"), File::FNM_DOTMATCH)
  end
end
