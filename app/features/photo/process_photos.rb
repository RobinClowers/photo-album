require "album_photos"
require "album_processor"
require "uploader"
require 'fileutils'

class ProcessPhotos
  attr_accessor :title, :to_process

  def initialize(title)
    @title = title
    original = album_photos.original
    processed = album_photos.keys(:web)
    @to_process = original - processed
    @paths = {}
  end

  def process
    to_process.each do |filename|
      puts "processing #{filename}"
      album_photos.download_original(filename, tmp_dir)
      processor.process(filename)
      Photo::VALID_VERSIONS.each do |version|
        uploader.upload(path_for(version), filename, version)
      end
      FileUtils.rm(File.join(tmp_dir, filename))
    end
    FileUtils.rm_rf(tmp_dir)
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
