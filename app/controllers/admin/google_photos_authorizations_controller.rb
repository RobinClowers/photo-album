class Admin::GooglePhotosAuthorizationsController < Admin::ApplicationController
  def new
    redirect_to auth_gateway.build_authorization_url(redirect_uri)
  end

  def create
    if params["code"]
      token = auth_gateway.request_token(params["code"], redirect_uri)
      session[:google_access_token_hash] = token
      GoogleAuthorization.create(
        user: current_user,
        scope: token[:scope],
        token_type: token[:token_type],
        expires_at: Time.at(token[:expires_at]),
        access_token: token[:access_token],
        refresh_token: token[:refresh_token],
      )
    end
    redirect_to admin_google_photos_albums_path
  end

  private
  def auth_gateway
    GooglePhotos::AuthorizationGateway.new
  end

  def redirect_uri
    admin_google_photos_authorizations_callback_url
  end
end
