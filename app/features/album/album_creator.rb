require 'album_photos'

class AlbumCreator
  attr_reader :title, :prefix

  def initialize(title)
    @title = title
    @prefix = title.to_url
  end

  def insert_all_photos
    added_images_count = 0
    puts "attempting to import #{valid_keys.count} images"
    valid_keys.each do |filename|
      added_images_count += 1 if insert_photo(filename)
    end
    puts "imported #{added_images_count} images"
  end

  def insert_photo(filename)
    Photo.create!(path: prefix, filename: filename, album: album)
  rescue ActiveRecord::RecordNotUnique
  end

  def update_cover_photo!(cover_photo_filename)
    album.update_cover_photo!(cover_photo_filename)
  end

  def album
    @album ||= Album.where(title: title).first_or_create!
  end

  def photos
    @photos ||= Rails.application.config.offline_dev ?
      LocalAlbumPhotos.new(prefix) : AlbumPhotos.new(prefix)
  end

  def valid_keys
    @valid_keys ||= photos.web.select { |f| f =~ /\.jpg|png\Z/i }
  end
end
