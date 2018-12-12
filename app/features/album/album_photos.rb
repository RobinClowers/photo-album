class AlbumPhotos
  attr_accessor :slug

  def initialize(slug)
    @slug = slug
  end

  def original
    keys(PhotoSize.original)
  end

  def keys(size)
    leaf_nodes(size.name).map { |pathname| pathname.basename.to_s }
  end

  def create(name, image_path, size, overwrite: false)
    key_to_create = key(size.name, name)
    if bucket.objects[key_to_create].exists?
      if overwrite
        puts "overwriting #{key_to_create}"
      else
        puts "object already exists at #{key_to_create}"
        return
      end
    else
      puts "creating #{key_to_create}"
    end
    bucket.objects.create(key_to_create, file: image_path)
  rescue Errno::EPIPE
    puts "Broken pipe, retrying..."
    retry
  rescue Net::OpenTimeout
    puts "Open timeout, retrying..."
    retry
  rescue Errno::ECONNRESET
    puts "Connection reset, retrying..."
    retry
  rescue SocketError
    puts "Socket erorr, retrying..."
    retry
  rescue AWS::S3::Errors::RequestTimeout
    puts "Request timeout, retrying..."
    retry
  rescue Errno::ENOENT => error
    raise unless error.errno == 2
    puts "#{name} does not exist, skipping"
  end

  def download_original(filename, target_dir)
    FileUtils.mkdir_p(target_dir)
    download(key(PhotoSize.original.name, filename), target_dir)
  end

  private

  def download(key, target_dir)
    filename = Pathname.new(key).basename
    filepath = "#{target_dir}/#{filename}"
    return if File.exist? filepath

    puts "writing to #{filepath}"

    File.open(filepath, 'wb') do |file|
      bucket.objects[key].read do |chunk|
         file.write(chunk)
      end
    end
  end

  def leaf_nodes(size_name)
    tree = bucket.as_tree(prefix: prefix(size_name))
    tree.children.select(&:leaf?)
      .select { |node| node.key =~ Photo::VALID_FILENAME_REGEX }
      .map { |node| Pathname.new(node.key) }
  end

  def key(size_name, name)
    [prefix(size_name), name].join('/')
  end

  def prefix(size_name)
    [slug, size_name].compact.join('/')
  end

  def s3
    @s3 ||= AWS::S3.new
  end

  def bucket
    @bucket ||= s3.buckets[Rails.application.config.bucket_name]
  end
end
