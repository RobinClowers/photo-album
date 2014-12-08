class PlusOneForm
  include ActiveModel::Model

  def initialize(params)
    @photo_id = params[:photo_id]
    @current_user = params[:current_user]
    @router = params[:router]
  end

  def self.model_name
    PlusOne.model_name
  end

  def save
    model.save
  rescue ActiveRecord::RecordNotUnique
  end

  def destroy
    existing_plus_one.destroy if existing_plus_one
  end

  def count
    plus_ones.count
  end

  def names
    plus_ones.map(&:user).map(&:name).join(', ')
  end

  def button_css_class
    existing_plus_one ? 'square-button active' : 'square-button'
  end

  def form_url
    existing_plus_one ? destroy_path : create_path
  end

  def form_method
    existing_plus_one ? :delete : :post
  end

  private

  attr_accessor :photo_id, :current_user, :router

  def model
    existing_plus_one || PlusOne.new(photo_id: photo_id, user: current_user)
  end

  def existing_plus_one
    plus_ones.where(user: current_user).first
  end

  def plus_ones
    PlusOne.where(photo_id: photo_id).includes(:user)
  end

  def destroy_path
    router.photo_plus_one_path(existing_plus_one, photo_id: photo_id)
  end

  def create_path
    router.photo_plus_ones_path
  end
end
