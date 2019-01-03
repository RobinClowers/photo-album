class ImportGoogleAlbumWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(google_auth_id, google_album_id, force = false)
    google_importer = GooglePhotos::Importer.new
    auth = GoogleAuthorization.find(google_auth_id)
    google_importer.import(auth, google_album_id, force: force)
  end
end
