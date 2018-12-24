class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      redirect_to after_confirmation_path_for(resource_name, resource)
    else
      redirect_to "#{home_url}/?emailConfirmed=false&error=#{resource.errors.full_messages.first}"
    end
  end

  def after_confirmation_path_for(resource_name, resource)
    "#{home_url}/?emailConfirmed=true"
  end
end
