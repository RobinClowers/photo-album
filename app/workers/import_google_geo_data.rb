class ImportGoogleGeoData
  include Sidekiq::Worker
  sidekiq_options queue: :utility

  def perform(path, force = false)
    geo_importer = GooglePhotos::GeoImporter.new(path)
    geo_importer.import(path, force: force)
  end
end
