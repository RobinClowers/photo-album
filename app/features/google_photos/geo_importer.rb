require 'json'

class GooglePhotos::GeoImporter
  attr_accessor :path, :logger

  def initialize(path, logger = Rails.logger)
    @path = path
    @logger = logger
  end

  def import(force: false)
    Dir[File.join(@path,"*.json")].each do |filename|
      json = JSON.parse(File.read(filename))
      set_geo_data(json, force: force)
    end
  end

  def set_geo_data(photo_metadata, force: false)
    photo = Photo.find_by_filename(photo_metadata["title"])
    unless photo
      @logger.warn("photo #{photo_metadata["title"]} not found")
      return
    end

    if !force && photo.lat && photo.lon
      @logger.info("Skipping #{photo.filename}")
      return
    end

    photo.lat = photo_metadata["geoData"]["latitude"]
    photo.lon = photo_metadata["geoData"]["longitude"]
    photo.save!
  end
end
