class Photos::FavoritesController < ApplicationController
  expose(:photos) { Photo.includes(:album, :versions).joins(:favorites).group("photos.id") }

  def index
    share_photo = photos.first || Photo::Nil.instance
    render json: {
      photos: photos.map { |photo|
        photo.as_json.merge({
          favorites: {
            "count" => 0,
            "names" => [],
            "current_user_favorite" => nil
          }
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
