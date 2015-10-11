class ProcessPhotosWorker
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(title, versions: :all)
    require 'process_photos'
    ProcessPhotos.new(title).process(versions)
  end
end
