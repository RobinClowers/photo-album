require "album_photos"
require "album_processor"
require "uploader"
require 'fileutils'

class ProcessPhotos
  attr_accessor :album

  def initialize(slug)
    @album = Album.includes(:photos).find_by_slug(slug.to_s)
    raise "Album not found with slug: #{album.slug}" unless @album
    @paths = {}
  end

  def process_album(versions = :all, force: false)
    versions = versions_to_process(versions)
    original = album_photos.original
    if force
      process_images(original, versions, force: force)
    else
      to_process = original - processed(versions)
      process_images(to_process, versions, force: force)
    end
  end

  def process_images(images, versions = :all, force: false)
    versions = versions_to_process(versions)
    images.each do |path|
      puts "processing #{path}"
      album_photos.download_original(path, tmp_dir)
      filename = Pathname.new(path).basename
      processor.process(filename, versions: versions, force: force)
      versions.each do |version|
        uploader.upload(path_for(version), path, version, overwrite: force)
        album.photos.find_by_filename(filename.to_s).has_version!(version)
      end
      FileUtils.rm(File.join(tmp_dir, path))
    end
    FileUtils.rm_rf(tmp_dir)
  end

  def versions_to_process(versions)
    return Photo::VALID_VERSIONS_TO_PROCESS if versions == :all
    versions
  end

  def processed(versions)
    @processed ||= versions.map { |version| exisiting_version_images(version) }.inject(:&)
  end

  def exisiting_version_images(version)
    album_photos.keys(version)
  end

  def path_for(version)
    @paths[version] ||= File.join(tmp_dir, version.to_s)
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
