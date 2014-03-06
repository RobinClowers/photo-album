class SessionsController < ApplicationController
  def create
    session[:user_id] = user.id
    redirect_to root_path, :notice => 'Welcome!'
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
