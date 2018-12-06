class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :store_return_url
  after_action :set_csrf_header

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionView::MissingTemplate, with: :render_404
  rescue_from ActionController::UnknownFormat, with: :render_404

  def render_404
    render '404', status: :not_found, formats: [:html]
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

  def return_path
    home_url
  end

  def home_url
    ENV.fetch("FRONT_END_ROOT")
  end
  helper_method :home_url

  def set_csrf_header
    if protect_against_forgery?
      headers['X-CSRF-Token'] = form_authenticity_token
    end
  end
end
