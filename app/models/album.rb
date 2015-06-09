class Album < ActiveRecord::Base
  has_many :photos, inverse_of: :album
  belongs_to :cover_photo, class_name: 'Photo'

  before_create :generate_slug

  scope :active, -> { where.not(published_at: nil, cover_photo_id: nil) }
  scope :unpublished, -> { where(published_at: nil) }

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
    update_attributes!(cover_photo: photos.find_by_filename(filename))
  end

  def cover_photo_filename
    return '' unless cover_photo
    cover_photo.filename
  end

  def publish!
    update_attributes!(published_at: Time.current)
  end

  # these methods should be in a presenter
  def cover_photo_insecure_url
    cover_photo.insecure_url if cover_photo
  end

  def cover_photo_secure_url
    cover_photo.secure_url if cover_photo
  end

  def cover_photo_thumb_url
    cover_photo.thumb_url if cover_photo
  end
end
