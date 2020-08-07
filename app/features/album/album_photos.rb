class AlbumPhotos
  attr_accessor :slug, :logger

  def initialize(slug)
    @slug = slug
    @logger = Rails.logger
  end

  def original
    keys(PhotoSize.original)
  end

  def keys(size)
    version(size.name).map { |pathname| pathname.basename.to_s }
  end

  def create(name, image_path, size, overwrite: false)
    key_to_create = key(size.name, name)
    logger.info("Attempting to upload #{image_path} to s3://#{key_to_create}")
    if bucket.objects[key_to_create].exists?
      if overwrite
        logger.info("Overwriting s3://#{key_to_create}")
      else
        logger.info("Object already exists at s3://#{key_to_create}")
        return
      end
    else
      logger.info("Uploading s3://#{key_to_create}")
    end
    bucket.objects.create(key_to_create, file: image_path)
  rescue Errno::EPIPE
    logger.info("Broken pipe, retrying...")
    retry
  rescue Net::OpenTimeout
    logger.info("Open timeout, retrying...")
    retry
  rescue Errno::ECONNRESET
    logger.info("Connection reset, retrying...")
    retry
  rescue SocketError
    logger.info("Socket erorr, retrying...")
    retry
  rescue Aws::S3::Errors::RequestTimeout
    logger.info("Request timeout, retrying...")
    retry
  rescue Errno::ENOENT => error
    raise unless error.errno == 2
    logger.info("#{name} does not exist, skipping")
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

    logger.info("Downloading s3://#{key} to #{filepath}")

    File.open(filepath, 'wb') do |file|
      s3.get_object({ bucket: bucket_name, key: key }, target: file)
    end
  end

  def version(size_name)
    tree = bucket.objects(prefix: slug)
      .select { |object|
        object.key =~ /.*\/#{size_name}/ &&
        object.key =~ Photo::VALID_FILENAME_REGEX
      }
      .map { |object| Pathname.new(object.key) }
  end

  def key(size_name, name)
    [prefix(size_name), name].join('/')
  end

  def prefix(size_name)
    [slug, size_name].compact.join('/')
  end

  def s3
    @bucket ||= Aws::S3::Client.new
  end

  def bucket
    @bucket ||= Aws::S3::Bucket.new(bucket_name)
  end

  def bucket_name
    Rails.application.config.bucket_name
  end
end
