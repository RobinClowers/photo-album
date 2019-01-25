class AlbumQuery
  attr_reader :slug, :album_list, :album, :current_user

  def initialize(params)
    @current_user = params[:current_user]
    @slug = params[:slug]
    @album_list ||= AlbumListQuery.new(current_user: current_user)
    @album = album_list.active.includes(
      { photos: :versions }, { cover_photo: :versions }).find_by_slug!(slug)
  end

  def as_json(_options = {})
    cover_photo = album.cover_photo
    {
      user: current_user,
      album: build_album(album),
      share_photo: {
        url: cover_photo.original_version.url,
        width: cover_photo.original_version.width,
        height: cover_photo.original_version.height,
      },
    }
  end

  def build_album(album)
    result = album.as_json(include: :cover_photo)
    result["photos"] = album.photos.map { |photo|
      json = photo.as_json(include: [:comments, {favorites: {include: :user}}])
      json["favorites"] = FavoritesMapper.map(photo.favorites, current_user)
      json["albumSlug"] = @album.slug
      json
    }
    result
  end
end
