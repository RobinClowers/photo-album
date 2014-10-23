class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render 'public/404', status: :not_found
  end

  def current_user
    @current_user ||= user_id && User.find_by_id(user_id) || User::NullUser.new
  end
  helper_method :current_user

  def user_id
    session[:user_id]
  end
end
