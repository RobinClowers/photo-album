class ProcessPhotosWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(album_title, photo_filenames, versions=:all)
    ProcessPhotos.new(album_title).process_images(photo_filenames, versions.map(&:to_sym))
  end
end
