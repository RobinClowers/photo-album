require 'album_photos'

class AlbumCreator
  attr_reader :title, :slug

  def initialize(title)
    @title = title
    @slug = AlbumSlug.new(title)
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
    versions = versions_for(filename)
    Photo.create!(path: slug, filename: filename, album: album, versions: versions)
  rescue ActiveRecord::RecordNotUnique
  end

  def versions_for(filename)
    AlbumProcessor::VERSIONS.keys.select do |version|
      photos.keys(version).include?(filename)
    end
  end

  def update_cover_photo!(cover_photo_filename)
    album.update_cover_photo!(cover_photo_filename)
  end

  def album
    @album ||= Album.where(title: title).first_or_create!
  end

  def photos
    @photos ||= Rails.application.config.offline_dev ?
      LocalAlbumPhotos.new(slug) : AlbumPhotos.new(slug)
  end

  def valid_keys
    @valid_keys ||= photos.web.select { |f| f =~ /\.jpg|png\Z/i }
  end
end
