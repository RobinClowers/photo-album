class ProcessAllAlbumsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform
    Album.pluck(:slug).each do |slug|
      ProcessAlbumWorker.perform_async(slug)
    end
  end
end
