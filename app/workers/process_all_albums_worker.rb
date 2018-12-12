class ProcessAllAlbumsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform
    Album.pluck(:slug).each do |slug|
      ProcessPhotos.new(slug).process_album(
        PhotoSize.from_names(version_names),
      )
    end
  end
end
