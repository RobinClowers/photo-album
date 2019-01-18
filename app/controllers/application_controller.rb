class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_action :set_csrf_cookie

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionView::MissingTemplate, with: :render_404
  rescue_from ActionController::UnknownFormat, with: :render_404

  def render_404
    render json: { error: 'not_found' }, status: :not_found
  end

  def current_user
    super || User::NullUser.new
  end
  helper_method :current_user

  def user_id
    session[:user_id]
  end

  def home_url
    ENV.fetch("FRONT_END_ROOT")
  end
  helper_method :home_url

  def set_csrf_cookie
    if protect_against_forgery?
      headers['X-CSRF-Token'] = form_authenticity_token
    end
  end

  protected

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource)
    home_url
  end
end
