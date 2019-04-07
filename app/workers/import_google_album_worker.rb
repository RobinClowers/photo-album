class ImportGoogleAlbumWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(google_auth_id, google_album_id, _title, force = false)
    auth = GoogleAuthorization.find(google_auth_id)
    google_importer = GooglePhotos::Importer.new(auth, google_album_id)
    google_importer.import(force: force)
  end
end
