class DestroyAlbum
  def self.execute(slug)
    album = Album.includes(photos: :photo_versions).find_by_slug(slug)
    PhotoVersion.where(photo: [album.photos]).delete_all
    Photo.where(album: album).delete_all
    album.delete
  end
end
