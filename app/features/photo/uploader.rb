require 'album_photos'

class Uploader
  def initialize(slug)
    @slug = AlbumSlug.new(slug)
  end

  def upload(base_path, name, type=:web, overwrite: false)
    raise 'invalid type' unless Photo::VALID_VERSIONS.include? type.to_sym
    base_path = realpath(base_path)
    create(base_path, name, type, overwrite)
  end

  def upload_all(base_path, type=:web, overwrite: false)
    raise 'invalid type' unless Photo::VALID_VERSIONS.include? type.to_sym
    base_path = realpath(base_path)
    unless overwrite
      existing_photos = photos.keys(type)
      puts_skipped_photos existing_photos
    end

    valid_images(base_path).each do |filename|
      if overwrite || !existing_photos.include?(filename)
        create(base_path, filename, type, overwrite)
      end
    end

    puts "Finished!"
  end

  private

  def realpath(path)
    File.realpath(File.expand_path(path))
  end

  def puts_skipped_photos(existing_photos)
    return unless existing_photos.count > 0
    puts "Skipping #{existing_photos.count} photos: "
    puts existing_photos
  end

  def create(base_path, name, type, overwrite)
    photos.create(name, File.join(base_path, name), type: type, overwrite: overwrite)
  end

  def photos
    @photos ||= AlbumPhotos.new(@slug)
  end

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ Photo::VALID_FILENAME_REGEX }
  end
end
