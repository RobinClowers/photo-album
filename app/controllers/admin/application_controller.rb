class Admin::ApplicationController < ApplicationController
  before_filter :require_admin

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
end
