class ProcessPhotosWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(album_slug, photo_filenames, versions=[:all], force=false)
    ProcessPhotos.new(album_slug).process_images(
      photo_filenames,
      versions.map(&:to_sym),
      force: force.present?
    )
  end
end
