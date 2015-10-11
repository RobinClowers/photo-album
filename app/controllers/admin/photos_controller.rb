class Admin::PhotosController < Admin::ApplicationController
  expose(:photo) { Photo.find(params[:id]) }

  def update
    if photo.update_attributes(photo_attributes)
      head :ok
    else
      render json: photo.errors, status: :unprocessable_entity
    end
  end

  def edit
    render 'edit', layout: false
  end

  private

  def photo_attributes
    params.require(:photo).permit(:caption)
  end
end
