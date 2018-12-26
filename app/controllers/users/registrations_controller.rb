class Users::RegistrationsController < Devise::RegistrationsController
  clear_respond_to
  respond_to :json

  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:provider])
  end
end
