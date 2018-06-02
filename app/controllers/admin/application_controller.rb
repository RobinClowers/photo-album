class Admin::ApplicationController < ApplicationController
  before_action :require_admin

  rescue_from GoogleAuthenticationError, with: :redirect_to_google_auth

  def require_admin
    forbidden unless current_user.admin?
  end

  def forbidden
    if request.xhr?
      render nothing: true, status: :forbidden
    else
      redirect_to root_path
    end
  end

  def google_access_token_hash
    session[:google_access_token_hash]
  end

  def redirect_to_google_auth
    redirect_to admin_new_google_photos_authorization_path
  end
end
