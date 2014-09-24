namespace :album do
  desc "Upload all photos in an album"
  task :upload, [:path] => :environment do |t, args|
    path = File.expand_path(args.path)
    title = Pathname.new(path).basename.to_s.parameterize
    s3 = AWS::S3.new

    bucket = s3.buckets['robin-photos']
    tree = bucket.as_tree(prefix: title)
    existing_photos = tree.children.select(&:leaf?).map(&:key)

    images = valid_images(path)
    images.each do |image|
      key = "#{title}/#{image}"
      unless existing_photos.include?(key)
        puts "creating #{key}"
        bucket.objects.create(key, "#{path}/#{image}")
      end
    end
  end

  desc "Create an album from photos on s3"
  task :create, [:title] => :environment do |t, args|
    require "album_creator"

    AlbumCreator.new(args.title).insert_all_photos_from_s3
  end

  desc "Sets the cover photo for an album"
  task :update_cover_photo, [:title, :filename] => :environment do |t, args|
    photo = Photo.find_by_filename!(args.filename)
    Album.find_by_title!(args.title).update_attributes!(cover_photo: photo)
  end

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ /\.jpg|png\Z/i }
  end
end
