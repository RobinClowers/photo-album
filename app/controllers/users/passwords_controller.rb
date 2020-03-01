class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token, only: [:create]
  clear_respond_to
  respond_to :json
end
