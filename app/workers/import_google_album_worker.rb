class ImportGoogleAlbumWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(google_access_token_hash, google_album_id, force = false)
    google_importer = GooglePhotos::Importer.new
    google_importer.import(google_access_token_hash, google_album_id, force: force)
  end
end
