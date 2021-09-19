class Admin::PhotosController < Admin::ApplicationController
  expose(:photo) { Photo.find(params[:id]) }

  def update
    if photo.update(photo_attributes)
      head :ok
    else
      render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def photo_attributes
    params.require(:photo).permit(:caption)
  end
end
