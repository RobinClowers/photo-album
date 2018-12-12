class ProcessAlbumWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(slug, version_names = 'all')
    versions = PhotoSize.from_names(version_names)
    ProcessPhotos.new(slug).process_album(versions)
  end
end
