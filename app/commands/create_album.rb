class CreateAlbum < ActiveInteraction::Base
  string :slug, :title, :cover_photo_filename

  validates :slug, :title, presence: true

  def initialize(params)
    super(params)
    self.title = ::AlbumSlug.new(slug).to_title if slug
    @album = Album.new(album_attributes(params))
  end

  def to_model
    @album
  end

  def execute
    @album = Album.create(album_attributes(inputs))
    if @album.valid?
      AlbumCreator.new(title).insert_all_photos
      @album.update_cover_photo!(cover_photo_filename)
    else
      errors.merge!(@album.errors)
    end
    @album
  end

  def album_attributes(params)
    params.select { |k| [:title, :slug].include?(k) }
  end
end
