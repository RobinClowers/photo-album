namespace :album do
  desc "Upload all photos in an album"
  task :upload, [:path] => :environment do |t, args|
    require 'uploader'

    slug = AlbumSlug.new(Pathname.new(args.path).basename.to_s)
    Uploader.new(slug).upload_all(args.path, :original)
  end

  desc "Import geo data for an album"
  task :geo_import, [:path] => :environment do |t, args|
    geo_importer = GooglePhotos::GeoImporter.new(args.path, Logger.new(STDOUT))
    geo_importer.import(force: false)
  end
end
