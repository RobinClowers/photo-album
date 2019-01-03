class Admin::ApplicationController < ApplicationController
  before_action :require_admin

  rescue_from GoogleAuthenticationError, with: :redirect_to_google_auth

  def require_admin
    forbidden unless current_user.admin?
  end

  def forbidden
    if request.xhr?
      head :forbidden
    else
      redirect_to root_path
    end
  end

  def google_authorization
    GoogleAuthorization.find_by_user_id(current_user) or
      raise GoogleAuthenticationError.new("Missing google authentication")
  end

  def redirect_to_google_auth
    redirect_to admin_new_google_photos_authorization_path
  end
end
