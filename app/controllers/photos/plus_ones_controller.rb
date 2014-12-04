class Photos::PlusOnesController < ApplicationController
  before_filter :require_signed_in
  layout false

  expose(:plus_one) { PlusOne.new(photo_id: photo_id, user: current_user) }
  expose(:count) { plus_one_count == 0 ? 1 : plus_one_count}
  expose(:button_css_class) { existing_plus_one? ? 'voted' : '' }

  def index
  end

  def create
    create_plus_one
    render 'index', status: :created
  end

  def create_plus_one
    !plus_one.save
  rescue ActiveRecord::RecordNotUnique
  end

  def photo_id
    params[:photo_id]
  end

  def plus_one_count
    @plus_one_count ||= PlusOne.where(photo_id: photo_id).count
  end

  def existing_plus_one?
    PlusOne.where(photo_id: photo_id, user: current_user).exists?
  end
end
