class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    session[:user_id] = user.id
    user.update_attributes(email: auth["info"]["email"])
    redirect_to return_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to return_path
  end

  private

  def auth
    request.env["omniauth.auth"]
  end

  def user
    @user ||= existing_user || User.create_with_omniauth(auth)
  end

  def existing_user
    @user ||= User.where(provider: auth["provider"], uid: auth["uid"]).first
  end

  def return_path
    session[:return_url] || root_path
  end
end
