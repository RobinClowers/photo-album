class ReprocessGooglePhotoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(google_auth_id, google_album_id, filename, force = false)
    auth = GoogleAuthorization.find(google_auth_id)
    google_importer = GooglePhotos::Importer.new(auth, google_album_id)
    google_importer.reprocess(filename, force: force)
  end
end
