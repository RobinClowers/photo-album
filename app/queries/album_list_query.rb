class AlbumListQuery
  attr_reader :albums, :current_user

  def initialize(params)
    @current_user = params[:current_user]
    @albums = active.
      includes(cover_photo: [:versions, :album]).
      order(first_photo_taken_at: :desc)
  end

  def active
    if current_user.admin?
      Album.all
    else
      Album.active
    end
  end

  def as_json(_options = {})
    {
      user: current_user,
      albums: albums.as_json(include: :cover_photo),
      share_photo: {
        url: cover_photo_version.url,
        width: cover_photo_version.width,
        height: cover_photo_version.height,
      },
    }
  end

  def cover_photo_version
    if albums.first
      albums.first.cover_photo.original_version
    else
      PhotoVersion::Nil.instance
    end
  end
end
