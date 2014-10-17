require 'album_photos'

class Uploader
  attr_accessor :path, :title

  def initialize(path, title: nil)
    @path = File.realpath(File.expand_path(path))
    @title = title || Pathname.new(path).basename.to_s.to_url
  end

  def upload(name, type=:web)
    raise 'invalid type' unless [:web, :thumbs, :original].include? type.to_sym
    create(path, name, type)
  end

  def upload_all(type=:web)
    raise 'invalid type' unless [:web, :thumbs, :original].include? type.to_sym
    existing_photos = photos.keys(type)
    puts "Skipping #{existing_photos}"

    valid_images(path).each do |image|
      unless existing_photos.include?(image)
        create(path, image, type)
      end
    end
  end

  private

  def create(path, name, type)
    photos.create(name, File.join(path, name), type: type)
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
