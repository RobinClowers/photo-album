require 'album_photos'

class AlbumCreator
  attr_reader :title, :slug, :logger

  def initialize(title)
    @title = title
    @slug = AlbumSlug.new(title)
    @logger = Rails.logger
  end

  def insert_all_photos
    added_images_count = 0
    logger.info("attempting to import #{valid_keys.count} images")
    valid_keys.each do |filename|
      added_images_count += 1 if insert_photo(filename)
    end
    logger.info("imported #{added_images_count} images")
  end

  def insert_photo(filename)
    Photo.create!(path: slug.to_s, filename: filename, album: album)
  rescue ActiveRecord::RecordNotUnique
  end

  def album
    @album ||= Album.where(title: title).first_or_create!
  end

  def photos
    @photos ||= Rails.application.config.offline_dev ?
      LocalAlbumPhotos.new(slug) : AlbumPhotos.new(slug)
  end

  def valid_keys
    @valid_keys ||= photos.original.select { |f| f =~ /\.jpg|png\Z/i }
  end
end
