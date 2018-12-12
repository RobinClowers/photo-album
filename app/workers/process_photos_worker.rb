class ProcessPhotosWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(album_slug, photo_filenames, version_names = 'all', force = false)
    ProcessPhotos.new(album_slug).process_images(
      photo_filenames,
      PhotoSize.from_names(version_names),
      force: force.present?
    )
  end
end
