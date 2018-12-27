class Albums::PhotosController < ApplicationController
  expose(:album) { Album.find_by_slug!(params[:album_id]) }
  expose(:photo) { album.photos.includes(:versions).find_by_filename!(filename) }
  expose(:comments) { Comment.where(photo: photo).includes(:user) }
  expose(:plus_ones) { PlusOne.where(photo: photo).includes(:user) }

  def show
    render json: {
      photo: photo.as_json().merge({
        favorites: {
          count: plus_ones.length,
          names: plus_ones_names,
          current_user_favorite: plus_ones.where(user: current_user).first,
        },
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

  MAX_PLUS_ONE_NAMES = 6
  def plus_ones_names
    users = plus_ones.map(&:user)
    result = users.take(MAX_PLUS_ONE_NAMES).map(&:name).join(', ')
    if users.length <= MAX_PLUS_ONE_NAMES
      result
    else
      "#{result} and #{users.length - MAX_PLUS_ONE_NAMES} more people"
    end
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
