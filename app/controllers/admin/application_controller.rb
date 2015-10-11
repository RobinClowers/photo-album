class Admin::ApplicationController < ApplicationController
  before_filter :require_admin

  def require_admin
    forbidden unless current_user.admin?
  end

  def forbidden
    if request.xhr?
      render nothing: true, status: :forbidden
    else
      redirect_to root_path
    end
  end
end
