class LocalAlbumPhotos < AlbumPhotos
  def initialize(slug)
    super(slug)
  end

  def leaf_nodes(type)
    path = File.join("public", "photos", prefix(type))
    Pathname.new(path).children.select(&:file?)
  end

  def create
    raise "Not Impelemented"
  end

  def download_original
    raise "Not Impelemented"
  end
end
