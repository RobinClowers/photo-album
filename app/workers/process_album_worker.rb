class ProcessAlbumWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(slug, versions = :all)
    ProcessPhotos.new(slug).process_album(versions)
  end
end
