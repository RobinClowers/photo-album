namespace :album do
  desc "Upload all photos in an album"
  task :upload, [:path] => :environment do |t, args|
    require 'uploader'

    Uploader.new(args.path).upload_all(:original)
  end

  desc "Create an album from photos on s3"
  task :create, [:title, :cover_photo_filename] => :environment do |t, args|
    require "album_creator"

    creator = AlbumCreator.new(args.title)
    creator.insert_all_photos_from_s3

    next unless args.cover_photo_filename
    creator.update_cover_photo!(args.cover_photo_filename)
  end

  desc "Sets the cover photo for an album"
  task :update_cover_photo, [:title, :filename] => :environment do |t, args|
    Album.find_by_title!(args.title).update_cover_photo!(args.filename)
  end

  desc "Process photos for a given album"
  task :process, [:title] => :environment do |t, args|
    require 'process_photos'

    ProcessPhotos.new(args.title).process
  end

  desc "Queue processing of photos for a given album"
  task :queued_process, [:title] => :environment do |t, args|
    ProcessPhotosWorker.perform_async(args.title)
  end
end
