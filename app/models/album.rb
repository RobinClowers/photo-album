class Album < ActiveRecord::Base
  has_many :photos, inverse_of: :album
  belongs_to :cover_photo, class_name: 'Photo'

  before_create :generate_slug

  scope :active, -> { where.not(cover_photo_id: nil) }

  default_scope -> { order(created_at: :desc) }

  def self.new_from_slug(slug)
    title = slug.titleize.gsub('And', '&')
    new(slug: slug, title: title)
  end

  def generate_slug
    self.slug = title.to_url
  end

  def to_param
    slug
  end

  def update_cover_photo!(filename)
    update_attributes!(cover_photo: Photo.find_by_filename!(filename))
  end

  def cover_photo_filename
    return '' unless cover_photo
    cover_photo.filename
  end
end
