class Photos::PlusOnesController < ApplicationController
  before_filter :require_signed_in
  layout false

  expose(:plus_one) { existing_plus_one || PlusOne.new(photo_id: photo_id, user: current_user) }
  expose(:count) { plus_one_count == 0 ? 1 : plus_one_count}
  expose(:button_css_class) { existing_plus_one ? 'square-button active' : 'square-button' }
  expose(:plus_one_form_url) { existing_plus_one ? destroy_path : photo_plus_ones_path }
  expose(:plus_one_form_method) { existing_plus_one ? :delete : :post }

  def index
  end

  def create
    create_plus_one
    render 'index', status: :created
  end

  def destroy
    existing_plus_one.destroy
    render 'index', status: :ok
  end

  private

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

  def existing_plus_one
    PlusOne.where(photo_id: photo_id, user: current_user).first
  end

  def destroy_path
    photo_plus_one_path(existing_plus_one, photo_id: photo_id)
  end
end
