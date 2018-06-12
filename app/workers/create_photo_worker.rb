class CreatePhotoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :web

  def perform(args = {})
    if Photo.where(filename: args.fetch("filename")).first
      Rails.logger.info("Photo #{args.fetch("filename")} exists") && return
    end
    Photo.create!(
      filename: args.fetch("filename"),
      path: args.fetch("path"),
      album_id: args["album_id"],
      caption: args["caption"],
      mime: args["mime"],
      google_id: args["google_id"],
      taken_at: args["taken_at"],
      width: args["width"],
      height: args["height"],
      camera_make: args["camera_make"],
      camera_model: args["camera_model"],
      focal_length: args["focal_length"],
      aperture_f_number: args["aperture_f_number"],
      iso_equivalent: args["iso_equivalent"],
    )
  end
end
