class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    session[:user_id] = user.id
    redirect_to session[:return_url] || root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out"
  end

  def auth
    request.env["omniauth.auth"]
  end

  def user
    @user ||= existing_user || User.create_with_omniauth(auth)
  end

  def existing_user
    @user ||= User.where(provider: auth["provider"], uid: auth["uid"]).first
  end
end
