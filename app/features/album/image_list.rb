class ImageList
  attr_reader :path, :versions

  def initialize(path, versions)
    @path = path
    @versions = versions
  end

  def each_image(filenames=all_images)
    filenames.each do |basename|
      image = Magick::ImageList.new(File.join(path, basename))
      yield image, basename
    end
  end

  def each_unprocessed_image
    each_image(unprocessed_images) { |*args| yield *args }
  end

  def unprocessed_images
    @unprocessed_images ||= all_images - processed_images
  end

  def processed_images
    @processed_images ||= versions.map { |version| exisiting_version_images(version) }.inject(:&)
  end

  def exisiting_version_images(version)
    valid_images(File.join(path, version.to_s))
  end

  def all_images
    @image_names ||= valid_images(path)
  end

  def valid_images(path)
    Dir.entries(path).select { |f| f =~ /\.jpg|png\Z/i }
  end
end
