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
      album: album.as_json(include: [{photos: {include: [:comments, :favorites]}}, :cover_photo]),
      share_photo: {
        url: cover_photo.original_version.url,
        width: cover_photo.original_version.width,
        height: cover_photo.original_version.height,
      },
    }
  end
end
