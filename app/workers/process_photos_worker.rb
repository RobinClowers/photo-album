class ProcessPhotosWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(title)
    require 'process_photos'
    ProcessPhotos.new(title).process
  end
end
