class Album < ApplicationRecord
  has_many :photos, -> { order "taken_at" }, inverse_of: :album
  belongs_to :cover_photo, class_name: 'Photo'

  before_create :generate_slug

  scope :active, -> { where.not(published_at: nil).where.not(cover_photo_id: nil) }
  scope :unpublished, -> { where(published_at: nil) }

  attr_accessor :google_id

  def self.new_from_slug(slug)
    slug = ::AlbumSlug.new(slug)
    new(slug: slug.to_s, title: slug.to_title)
  end

  def self.update_first_photo_taken_at!
    all.each do |album|
      album.update_first_photo_taken_at!
    end
  end

  def update_first_photo_taken_at!
    self.first_photo_taken_at = photos.last.taken_at
    save!
  end

  def generate_slug
    self.slug = ::AlbumSlug.new(title) unless self.slug
  end

  def to_param
    slug
  end

  def update_cover_photo!(filename)
    update!(cover_photo: photos.find_by_filename(filename))
  end

  def cover_photo
    return Photo::Nil.instance unless attributes["cover_photo_id"]
    super
  end

  def publish!
    update!(published_at: Time.current)
  end
end
