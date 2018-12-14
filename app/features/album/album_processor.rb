require "rmagick"
require "fileutils"

class AlbumProcessor
  attr_reader :directory, :logger

  def initialize(dir)
    @directory = File.realpath(File.expand_path(dir))
    @logger = Rails.logger
    raise "### You must specify a directory containing images to process" unless File.directory?(directory)
  end

  def process(basename, sizes: PhotoSize.all, force: false, &block)
    image = Magick::ImageList.new(File.join(directory, basename))
    process_image(image, basename, sizes, force, block)
  end

  def create_versions(size, force: false, &block)
    guard_dir(size)
    each_image(force: force) do |image, basename|
      create_version(size, image, basename, force, block)
    end
  end

  private

  def process_image(image, basename, sizes, force, callback)
    auto_orient_image!(image)
    sizes.each do |size|
      create_version(size, image, basename, force, callback)
    end
  end

  def auto_orient_image!(image)
    if image.auto_orient!
      logger.info("Rotating #{image.filename}")
      image.write image.filename
    end
  end

  def create_version(size, image, basename, force, callback)
    guard_dir(size)
    filename = basename.sub(/\..+/, ".jpg")
    path = size.photo_path(directory, filename)
    return if File.exists?(path) && !force
    resized_image = image.change_geometry(size.geometry_string) { |height, width|
      if image_is_too_small?(image, height, width)
        logger.info("#{image.filename} is too small for #{size.name}, skipping")
        return
      end
      image.resize(height, width)
    }
    image.format = "JPEG"
    logger.info("Writing #{path}")
    resized_image.write(path) do |i|
      i.interlace = ::Magick::PlaneInterlace
    end
    callback.call(size, filename, resized_image) if callback
  end

  def guard_dir(size)
    FileUtils.mkdir_p(size.full_path(directory))
  end

  def image_is_too_small?(image, height, width)
    image.rows < width || image.columns < height
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
