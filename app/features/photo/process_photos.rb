require "album_photos"
require "album_processor"
require "uploader"
require 'fileutils'

class ProcessPhotos
  attr_accessor :album, :logger

  def initialize(slug)
    @logger = Rails.logger
    @album = Album.includes(:photos).find_by_slug(slug.to_s)
    raise "Album not found with slug: #{album.slug}" unless @album
    @paths = {}
  end

  def process_album(sizes = PhotoSize.all, force: false)
    original = album_photos.original
    if force
      process_images(original, sizes, force: force)
    else
      to_process = original - processed(sizes)
      process_images(to_process, sizes, force: force)
    end
  end

  def process_images(images, sizes = PhotoSize.all, force: false)
    images.each do |filename|
      logger.info("Processing #{filename}")
      album_photos.download_original(filename, tmp_dir)
      photo = album.photos.find_by_filename(filename)
      exif_data = ExifReader.extract_photo_model_data(File.join(tmp_dir, filename))
      photo.update_attributes!(exif_data)
      processor.process(
        filename,
        sizes: sizes,
        force: force
      ) do |size, version_filename, image|
        uploader.upload(path_for(size), version_filename, size, overwrite: force)
        photo.has_size!(size, version_filename, image.mime_type, image.columns, image.rows)
      end
      FileUtils.rm(File.join(tmp_dir, filename))
    end
    FileUtils.rm_rf(tmp_dir)
  end

  def processed(sizes)
    @processed ||= sizes.map { |size| exisiting_version_images(size) }.inject(:&)
  end

  def exisiting_version_images(size)
    album_photos.keys(size)
  end

  def path_for(size)
    @paths[size.name] ||= File.join(tmp_dir, size.name)
  end

  def tmp_dir
    @tmp_dir ||= "tmp/photo_processing/#{album.slug}"
  end

  def album_photos
    @album_photos ||= AlbumPhotos.new(album.slug)
  end

  def processor
    @processor ||= AlbumProcessor.new(tmp_dir)
  end

  def uploader
    @uploader ||= Uploader.new(album.slug)
  end
end
