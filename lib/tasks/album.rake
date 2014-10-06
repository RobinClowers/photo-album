namespace :album do
  desc "Upload all photos in an album"
  task :upload, [:path] => :environment do |t, args|
    require 'uploader'

    Uploader.new(args.path).upload
  end

  desc "Create an album from photos on s3"
  task :create, [:title, :cover_photo_filename] => :environment do |t, args|
    require "album_creator"

    AlbumCreator.new(args.title).insert_all_photos_from_s3

    next unless args.cover_photo_filename
    Album.find_by_title!(args.title).update_cover_photo!(args.cover_photo_filename)
  end

  desc "Sets the cover photo for an album"
  task :update_cover_photo, [:title, :filename] => :environment do |t, args|
    Album.find_by_title!(args.title).update_cover_photo!(args.filename)
  end
end
