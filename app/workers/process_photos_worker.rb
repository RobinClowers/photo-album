class ProcessPhotosWorker
  include Sidekiq::Worker

  def perform(title)
    require 'process_photos'
    ProcessPhotos.new(title).process
  end
end
