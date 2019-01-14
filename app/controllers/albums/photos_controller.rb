class Albums::PhotosController < ApplicationController
  expose(:album) { Album.find_by_slug!(params[:album_id]) }
  expose(:photo) { album.photos.includes(:versions).find_by_filename!(filename) }
  expose(:comments) { Comment.where(photo: photo).includes(:user) }
  expose(:plus_ones) { PlusOne.where(photo: photo).includes(:user) }

  def show
    render json: {
      photo: photo.as_json().merge({
        favorites: FavoritesMapper.map(plus_ones, current_user)
      }),
      next_photo_filename: next_photo_filename,
      previous_photo_filename: previous_photo_filename,
      album: album,
      user: current_user,
      comments: comments,
    }
  end

  private

  def filename
    "#{params[:id]}.#{params[:format]}"
  end

  def photo_ids
    @photo_ids = album.photo_ids
  end

  def next_photo_filename
    index = photo_ids.index(photo.id)

    if index >= (photo_ids.count - 1)
      nil
    else
      Photo.find(photo_ids[index + 1]).filename
    end
  end

  def previous_photo_filename
    index = photo_ids.index(photo.id)
    if index == 0
      nil
    else
      Photo.find(photo_ids[index - 1]).filename
    end
  end
end
