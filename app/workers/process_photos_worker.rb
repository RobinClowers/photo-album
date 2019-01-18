class ProcessPhotosWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(album_slug, photo_filenames, version_names = 'all', force = false)
    processor = ProcessPhotos.new(album_slug)
    processor.process_images(
      photo_filenames,
      PhotoSize.from_names(version_names),
      force: force.present?
    )
    FileUtils.rm_rf(processor.tmp_dir) unless ENV["KEEP_PHOTO_CACHE"]
  end
end
