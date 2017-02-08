class ProcessAlbumWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(title, versions=:all)
    ProcessPhotos.new(title).process_album(versions)
  end
end
