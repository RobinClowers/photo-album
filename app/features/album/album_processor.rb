require "rmagick"
require "fileutils"

class AlbumProcessor
  attr_reader :directory

  def initialize(dir)
    @directory = File.realpath(File.expand_path(dir))
    raise "### You must specify a directory containing images to process" unless File.directory?(directory)
  end

  def process(basename, sizes: PhotoSize.all, force: false)
    image = Magick::ImageList.new(File.join(directory, basename))
    process_image(image, basename, sizes: sizes, force: force)
  end

  def create_versions(size, force: false)
    guard_dir(size)
    each_image(force: force) do |image, basename|
      create_version(size, image, basename, force: force)
    end
  end

  private

  def process_image(image, basename, sizes: PhotoSize.all, force: false)
    auto_orient_image!(image)
    sizes.each do |size|
      create_version(size, image, basename, force: force)
    end
  end

  def auto_orient_image!(image)
    if image.auto_orient!
      puts "rotating #{image.filename}"
      image.write image.filename
    end
  end

  def create_version(size, image, basename, force: false)
    guard_dir(size)
    path = size.photo_path(directory, basename.sub(/\..+/, ".jpg"))
    return if File.exists?(path) && !force
    resized_image = image.change_geometry(size.geometry_string) { |height, width|
      image.resize(height, width)
    }
    puts "writing #{size.name} size for #{image.filename}"
    resized_image.write(path) do |i|
      i.interlace = ::Magick::PlaneInterlace
    end
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
