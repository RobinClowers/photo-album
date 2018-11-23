class Albums::PhotosController < ApplicationController
  expose(:album) { Album.find_by_slug(params[:album_id]) }
  expose(:photo) { album.photos.find_by_filename(filename) }

  def show
    render json: {
      photo: photo,
      album: album,
      user: current_user,
    }
  end

  private

  def filename
    "#{params[:id]}.#{params[:format]}"
  end
end
