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
    puts_skipped_photos existing_photos

    valid_images(path).each do |image|
      unless existing_photos.include?(image)
        create(path, image, type)
      end
    end

    puts "Finished!"
  end

  private

  def puts_skipped_photos(existing_photos)
    return unless existing_photos.count > 0
    puts "Skipping #{existing_photos.count} photos: "
    puts existing_photos
  end

  def create(path, name, type)
    photos.create(name, File.join(path, name), type: type)
  end

  def photos
    @photos ||= AlbumPhotos.new(title)
  end

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ /\.jpg|png\Z/i }
  end
end
