# Because we are using Cloudflare flexible SSL, requests are not ssl by the time they
# reach the rails app. Therefore omniauth won't use an https callback url unless we
# override this config value.
OmniAuth.config.full_host = ENV.fetch("FULL_HOST")

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
    :client_options => {
      :site => 'https://graph.facebook.com/v2.6',
      :authorize_url => "https://www.facebook.com/v2.6/dialog/oauth"
    }
end
