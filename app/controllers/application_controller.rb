class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :store_return_url

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render 'public/404', status: :not_found
  end

  def current_user
    @current_user ||= CurrentUser.get(request)
  end
  helper_method :current_user

  def user_id
    session[:user_id]
  end

  def require_signed_in
    render nothing: true, status: :unauthorized unless current_user.signed_in?
  end

  def store_return_url
    return if current_user.signed_in?
    return if request.xhr?
    return if request.path =~ /auth\/\w*\/callback/
    session[:return_url] = request.path
  end
end
