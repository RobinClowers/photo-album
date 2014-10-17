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
    AlbumPhotos.new(title).download_original(tmp_dir)
    AlbumProcessor.new(tmp_dir).process_images

    Uploader.new("#{tmp_dir}/thumbs", title: title).upload(:thumb)
    Uploader.new("#{tmp_dir}/web", title: title).upload(:web)
    FileUtils.rm_rf(tmp_dir)
  end

  def tmp_dir
    @tmp_dir ||= "tmp/photo_processing/#{title}"
  end
end
