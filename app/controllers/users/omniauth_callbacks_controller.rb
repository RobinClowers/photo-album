class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect(@user)
  end

  def failure
    redirect_to "#{home_url}/?error=Facebook login failed: #{failure_message}"
  end
end
