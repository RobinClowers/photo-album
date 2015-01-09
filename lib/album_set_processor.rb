require "album_processor"

class AlbumSetProcessor
  attr_reader :set_path, :ignore_file

  def initialize(set_path, ignore_file: '.album_set_ignore')
    @set_path = File.realpath(File.expand_path(set_path))
    @ignore_file = ignore_file
  end

  def process
    each_entry do |entry, full_path|
      ObjectSpace.garbage_collect # seems bad, hopefully there is a better way
      processor = AlbumProcessor.new(full_path)
      processor.process_all
    end
  end

  def auto_orient_images
    each_entry do |entry, full_path|
      AlbumProcessor.new(full_path).auto_orient_images
    end
  end

  def each_entry
    Dir.foreach set_path do |entry|
      full_path = File.join(set_path, entry)
      next unless valid_album?(entry, full_path)
      puts "processing #{full_path}"
      yield entry, full_path
    end
  end

  def syncronize_photos
    each_entry do |entry, full_path|
      AlbumProcessor.new(full_path).insert_all_photos
    end
  end

  def valid_album?(name, full_path)
    return false unless File.directory?(full_path)
    return false if name =~ /\A\./
    return false if ignored?(name)
    return true
  end

  def ignored?(name)
    return ignores.include?(name)
  end

  def ignores
    @ignores ||= load_ignores.map(&:strip)
  end

  def load_ignores
    ignore_path = File.join(set_path, ignore_file)
    if File.exists? ignore_path
      IO.readlines(ignore_path)
    else
      []
    end
  end
end
