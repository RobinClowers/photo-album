require 'album_photos'

class Uploader
  attr_accessor :path, :title

  def initialize(path, title: nil)
    @path = File.realpath(File.expand_path(path))
    @title = title || Pathname.new(path).basename.to_s.to_url
  end

  def upload(type=:web)
    existing_photos = photos.keys(type)
    puts "Skipping #{existing_photos}"

    valid_images(path).each do |image|
      unless existing_photos.include?(image)
        image_path = "#{path}/#{image}"
        create(image, image_path, type)
      end
    end
  end

  private

  def create(image, image_path, type)
    photos.create(image, image_path, type: type)
  rescue Errno::EPIPE
    puts "Broken pipe, retrying..."
    retry
  end

  def photos
    @photos ||= AlbumPhotos.new(title)
  end

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ /\.jpg|png\Z/i }
  end
end