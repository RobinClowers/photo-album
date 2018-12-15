require "fileutils"

class AlbumProcessor
  attr_reader :directory, :logger

  def initialize(dir)
    @directory = File.realpath(File.expand_path(dir))
    @logger = Rails.logger
    raise "### You must specify a directory containing images to process" unless File.directory?(directory)
  end

  def process(basename, sizes: PhotoSize.all, force: false, &block)
    process_image(basename, sizes, force, block)
  end

  def create_versions(size, force: false, &block)
    guard_dir(size)
    each_image(force: force) do |image, basename|
      create_version(size, basename, force, block)
    end
  end

  private

  def process_image(basename, sizes, force, callback)
    sizes.each do |size|
      create_version(size, basename, force, callback)
    end
  end

  def create_version(size, basename, force, callback)
    image = MiniMagick::Image.open(File.join(directory, basename))
    if size == PhotoSize.original
      callback.call(size, basename, image) if callback
      return
    end
    guard_dir(size)
    filename = basename.sub(/\..+/, ".jpg")
    path = size.photo_path(directory, filename)
    return if File.exists?(path) && !force
    width, height = size.calculate(image.width, image.height)
    if width == :invalid || height == :invalid
      logger.info("#{basename} is too small for #{size.name}, skipping")
      return
    end
    image.format("JPEG")
    image.combine_options do |i|
      i.auto_orient
      i.resize(size.geometry_string)
      i.interlace("plane")
    end
    image.write(path)
    image_optim.optimize_image!(path)
    callback.call(size, filename, image) if callback
  end

  def image_optim
    @image_optim ||= ImageOptim.new({ pngout: false, svgo: false })
  end

  def guard_dir(size)
    FileUtils.mkdir_p(size.full_path(directory))
  end

  def image_list
    @image_list ||= ImageList.new(directory, PhotoSize.all)
  end

  def each_image(force: false)
    if force
      image_list.each_image { |*args| yield(*args) }
    else
      image_list.each_unprocessed_image { |*args| yield(*args) }
    end
  end
end
