require "album_photos"
require "album_processor"
require "uploader"
require 'fileutils'

class ProcessPhotos
  attr_accessor :title

  def initialize(title)
    @title = title
  end

  def process
    to_process = album_photos.original
    to_process.each do |filename|
      puts "processing #{filename}"
      album_photos.download_original(filename, tmp_dir)
      processor.process(filename)
      thumbs_uploader.upload(:thumbs)
      thumbs_uploader.upload(:web)
      FileUtils.rm(File.join(tmp_dir, filename))
    end
    FileUtils.rm_rf(tmp_dir)
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

  def thumbs_uploader
    @thumbs_uploader ||= Uploader.new("#{tmp_dir}/thumbs", title: title)
  end

  def web_uploader
    @web_uploader ||= Uploader.new("#{tmp_dir}/web", title: title)
  end
end
