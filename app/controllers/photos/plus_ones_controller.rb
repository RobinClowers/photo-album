class Photos::PlusOnesController < ApplicationController
  before_filter :require_signed_in

  def create
    create_plus_one
    render nothing: true, status: :created
  end

  def create_plus_one
    PlusOne.create(user: current_user, photo_id: params[:photo_id])
  rescue ActiveRecord::RecordNotUnique
  end
end
