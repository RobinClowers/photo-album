class AppendPhotoVersionWorker
  include Sidekiq::Worker
  sidekiq_options queue: :web

  def perform(album_slug, filename, version)
    album = Album.find_by_slug(album_slug)
    album.photos.find_by_filename(filename).has_version!(version)
  end
end
