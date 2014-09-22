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

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ /\.jpg|png\Z/i }
  end
end
