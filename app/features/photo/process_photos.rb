require "album_photos"
require "album_processor"
require "uploader"
require 'fileutils'

class ProcessPhotos
  attr_accessor :title

  def initialize(title)
    @title = title
    @paths = {}
  end

  def process_album(versions = :all)
    versions = versions_to_process(versions)
    original = album_photos.original
    to_process = original - processed(versions)
    processing_images(to_process, versions)
  end

  def process_images(images, versions = :all)
    versions = versions_to_process(versions)
    images.each do |filename|
      puts "processing #{filename}"
      album_photos.download_original(filename, tmp_dir)
      processor.process(Pathname.new(filename).basename, versions: versions)
      versions.each do |version|
        uploader.upload(path_for(version), filename, version)
        AppendPhotoVersionWorker.perform_async(title.to_url, filename, version)
      end
      FileUtils.rm(File.join(tmp_dir, filename))
    end
    FileUtils.rm_rf(tmp_dir)
  end

  def versions_to_process(versions)
    return Photo::VALID_VERSIONS if versions == :all
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
    @tmp_dir ||= "tmp/photo_processing/#{title}"
  end

  def album_photos
    @album_photos ||= AlbumPhotos.new(title)
  end

  def processor
    @processor ||= AlbumProcessor.new(tmp_dir)
  end

  def uploader
    @uploader ||= Uploader.new(title)
  end
end
