namespace :process do
  # usage rake process:album['~/Pictures/Hawaii']
  desc "Create a set of thumbnails for the images in a given folder"
  task :album, :image_directory do |t, args|
    require "album_processor"

    args.with_defaults(:image_directory => '')
    processor = AlbumProcessor.new(args.image_directory)
    processor.process_images
  end

  # usage rake process:album_set['~/Pictures']
  desc "Create a set of thumbnails for each album in the given directory"
  task :album_set, :image_directory do |t, args|
    require "album_set_processor"

    args.with_defaults(:image_directory => '')
    processor = AlbumSetProcessor.new(args.image_directory)
    processor.process
    puts "finished"
  end
end

# usage rake auto_orient['~/Pictures/Hawaii']
desc "orients images based on their exif rotation data"
task :auto_orient, :image_directory do |t, args|
  require "album_processor"

  args.with_defaults(:image_directory => '')
  processor = AlbumProcessor.new(args.image_directory)
  processor.auto_orient_images!
end
