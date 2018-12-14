require 'album_photos'

class Uploader
  attr_reader :slug, :logger

  def initialize(slug)
    @slug = AlbumSlug.new(slug)
    @logger = Rails.logger
  end

  def upload(base_path, name, size, overwrite: false)
    base_path = realpath(base_path)
    create(base_path, name, size, overwrite)
  end

  def upload_all(base_path, size, overwrite: false)
    base_path = realpath(base_path)
    unless overwrite
      existing_photos = photos.keys(size)
      log_skipped_photos(existing_photos)
    end

    valid_images(base_path).each do |filename|
      if overwrite || !existing_photos.include?(filename)
        create(base_path, filename, size, overwrite)
      end
    end

    logger.info("Upload finished")
  end

  private

  def realpath(path)
    File.realpath(File.expand_path(path))
  end

  def log_skipped_photos(existing_photos)
    return unless existing_photos.count > 0
    logger.info("Skipping #{existing_photos.count} photos: ")
    logger.info(existing_photos)
  end

  def create(base_path, name, size, overwrite)
    photos.create(name, File.join(base_path, name), size, overwrite: overwrite)
  end

  def photos
    @photos ||= AlbumPhotos.new(slug)
  end

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ Photo::VALID_FILENAME_REGEX }
  end
end
