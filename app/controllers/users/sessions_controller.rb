class Users::SessionsController < Devise::SessionsController
  clear_respond_to
  respond_to :json

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end
