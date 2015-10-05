require "RMagick"

class AlbumProcessor
  attr_reader :directory
  VERSIONS = {
    web: -> (image) { image.resize_to_fit(1024, 1024) },
    small: -> (image) { image.resize_to_fit(320, 320) },
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

  def insert_all_photos
    @added_images_count = 0
    path = Pathname.new(directory).basename.to_s
    puts "attempting to import #{all_images.count} images"
    all_images.each do |basename|
      insert_photo(path, basename)
    end
    puts "imported #{@added_images_count} images"
  end

  def insert_photo(path, basename)
    album = Album.where(title: path).first_or_create
    Photo.create!(path: path.to_url, filename: basename, album: album)
    @added_images_count += 1
  rescue ActiveRecord::RecordNotUnique
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

  def each_image
    unprocessed_images.each do |basename|
      image = Magick::ImageList.new(File.join(directory, basename))
      yield image, basename
    end
  end

  def guard_dir(name)
    Dir.mkdir(name) unless Dir.exists?(name)
  end

  def unprocessed_images
    @unprocessed_images ||= all_images - processed_images
  end

  def processed_images
    @processed_images ||= VERSIONS.keys.map { |version| exisiting_version_images(version) }.inject(:&)
  end

  def exisiting_version_images(version)
    valid_images(File.join(directory, version.to_s))
  end

  def exisiting_thumbnail_images
    @exisiting_thumbnail_images ||= valid_images(File.join(directory, 'thumbs'))
  end

  def all_images
    @image_names ||= valid_images(directory)
  end

  def valid_images(directory)
    Dir.entries(directory).select { |f| f =~ /\.jpg|png\Z/i }
  end
end
