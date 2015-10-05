require "RMagick"

class AlbumProcessor
  attr_reader :directory
  VERSIONS = {
    web: -> (image) { image.resize_to_fit(1024, 1024) },
    small: -> (image) { image.resize_to_fill(320, 320) },
    thumbs: -> (image) { image.resize_to_fill(75, 75) },
}

  def initialize(dir)
    @directory = File.realpath(File.expand_path(dir))
    raise "### You must specify a directory containing images to process" unless File.directory?(directory)
    VERSIONS.keys.each do |version|
      guard_dir version_base_path(version)
    end
  end

  def version_path(version, basename)
    File.join(directory, version.to_s, basename)
  end

  def version_base_path(version)
    File.join(directory, version.to_s)
  end

  def process_all
    each_image do |image, basename|
      process_image(image, basename)
    end
  end

  def process(basename)
    image = Magick::ImageList.new(File.join(directory, basename))
    process_image(image, basename)
  end

  def process_image(image, basename)
    auto_orient_image!(image)
    VERSIONS.keys.each do |version|
      create_version(version, image, basename)
    end
  end

  def auto_orient_images!
    each_image do |image, basename|
      auto_orient_image!(image)
    end
  end

  def create_versions(version)
    guard_dir version_base_path(version)
    each_image do |image, basename|
      create_version(version, image, basename)
    end
  end

  def auto_orient_image!(image)
    if image.auto_orient!
      puts "rotating #{image.filename}"
      image.write image.filename
    end
  end

  def create_version(version, image, basename)
    path = version_path(version, basename)
    return if File.exists?(path)
    resized_image = VERSIONS[version].call(image)
    puts "writing #{version} version for #{image.filename}"
    resized_image.write(path)
  end

  def guard_dir(name)
    Dir.mkdir(name) unless Dir.exists?(name)
  end

  def image_list
    @image_list ||= ImageList.new(directory, VERSIONS.keys)
  end

  def each_image
    image_list.each_image { |*args| yield *args }
  end
end
