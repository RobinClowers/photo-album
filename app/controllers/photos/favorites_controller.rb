class Photos::FavoritesController < ApplicationController
  expose(:photos) {
    ids = Photo.joins(:favorites).group("photos.id").pluck(:id)
    Photo.includes(:album, :versions, { favorites: :user }).where(id: ids)
  }

  def index
    share_photo = photos.first || Photo::Nil.instance
    render json: {
      photos: photos.map { |photo|
        photo.as_json.merge({
          "albumSlug" => photo.album.slug,
          "favorites" => FavoritesMapper.map(photo.favorites, current_user),
        })
      },
      share_photo: {
        url: share_photo.original_version.url,
        width: share_photo.original_version.width,
        height: share_photo.original_version.height,
      },
      user: current_user,
    }
  end
end
