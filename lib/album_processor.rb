require "RMagick"

class AlbumProcessor
  attr_reader :directory, :web_dir, :thumbs_dir

  def initialize(directory)
    @directory = File.expand_path(directory)
    raise "### You must specify a directory containing images to process" unless File.directory?(directory)
    @web_dir = File.join(directory, 'web')
    @thumbs_dir = File.join(directory, 'thumbs')
    guard_dir @web_dir
    guard_dir @thumbs_dir
  end

  def insert_photos
    path = Pathname.new(directory).basename.to_s.to_url
    unprocessed_images.each do |filename|
      insert_photo(path, filename)
    end
  end

  def insert_photo(path, filename)
    Photo.create!(path: path, filename: filename)
  rescue ActiveRecord::RecordNotUnique
  end

  def process_images
    each_image do |image, basename|
      auto_orient_image!(image)
      create_thumbnail_image(image, basename)
      create_web_image(image, basename)
    end
  end

  def auto_orient_images!
    each_image do |image, filename|
      auto_orient_image!(image)
    end
  end

  def create_web_images
    guard_dir @web_dir
    each_image do |image, basename|
      create_web_image(image, basename)
    end
  end

  def create_thumbnail_images
    guard_dir @thumbs_dir
    each_image do |image, basename|
      create_thumbnail_image(image)
    end
  end

  def auto_orient_image!(image)
    if image.auto_orient!
      puts "rotating #{image.filename}"
      image.write image.filename
    end
  end

  def create_thumbnail_image(image, basename)
    thumb = image.resize_to_fill(75, 75)
    thumb.write(File.join(@thumbs_dir, basename))
  end

  def create_web_image(image, basename)
    web = image.resize_to_fit(1024, 1024)
    web.write(File.join(@web_dir, basename))
  end

  def each_image
    unprocessed_images.each do |filename|
      image = Magick::ImageList.new(File.join(directory, filename))
      yield image, filename
    end
  end

  def guard_dir(name)
    Dir.mkdir(name) unless Dir.exists?(name)
  end

  def unprocessed_images
    @unprocessed_images ||= all_images - processed_images
  end

  def processed_images
    @processed_images ||= exisiting_web_images & exisiting_thumbnail_images
  end

  def exisiting_web_images
    @exisiting_web_images ||= valid_images(File.join(directory, 'web'))
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
