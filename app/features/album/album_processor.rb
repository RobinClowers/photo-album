require "RMagick"

class AlbumProcessor
  attr_reader :directory
  VERSIONS = {
    web: -> (image) { image.resize_to_fit(1024, 1024) },
    small: -> (image) { image.resize_to_fill(240, 240) },
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

  def process(basename, versions: :all, force: false)
    image = Magick::ImageList.new(File.join(directory, basename))
    process_image(image, basename, versions: versions, force: force)
  end

  def process_image(image, basename, versions: :all, force: false)
    auto_orient_image!(image)
    versions_to_process(versions).each do |version|
      create_version(version, image, basename, force: force)
    end
  end

  def versions_to_process(versions)
    return Photo::VALID_VERSIONS_TO_PROCESS if versions == :all
    versions
  end

  def auto_orient_images!
    each_image do |image, basename|
      auto_orient_image!(image)
    end
  end

  def create_versions(version, force: false)
    guard_dir version_base_path(version)
    each_image(force: force) do |image, basename|
      create_version(version, image, basename, force: force)
    end
  end

  def auto_orient_image!(image)
    if image.auto_orient!
      puts "rotating #{image.filename}"
      image.write image.filename
    end
  end

  def create_version(version, image, basename, force: false)
    path = version_path(version, basename)
    return if File.exists?(path) && !force
    raise "No #{version.to_s} version configured" unless VERSIONS[version]
    resized_image = VERSIONS[version].call(image)
    puts "writing #{version} version for #{image.filename}"
    resized_image.write(path) do |i|
      if resized_image.mime_type == "image/jpeg"
        i.interlace = ::Magick::PlaneInterlace
      end
    end
  end

  def guard_dir(name)
    Dir.mkdir(name) unless Dir.exists?(name)
  end

  def image_list
    @image_list ||= ImageList.new(directory, VERSIONS.keys)
  end

  def each_image(force: false)
    if force
      image_list.each_image { |*args| yield *args }
    else
      image_list.each_unprocessed_image { |*args| yield *args }
    end
  end
end
