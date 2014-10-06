require 'album_photos'

class Uploader
  attr_accessor :path, :title

  def initialize(path)
    @path = File.expand_path(path)
    @title = Pathname.new(path).basename.to_s.to_url
  end

  def upload
    existing_photos = photos.original
    puts "Skipping #{existing_photos}"

    valid_images(path).each do |image|
      unless existing_photos.include?(image)
        image_path = "#{path}/#{image}"
        photos.create(image, image_path, type: :original)
      end
    end
  end

  private

  def photos
    @photos ||= AlbumPhotos.new(title)
  end

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ /\.jpg|png\Z/i }
  end
end
