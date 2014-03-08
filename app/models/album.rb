class Album < ActiveRecord::Base
  has_many :photos, inverse_of: :album
  belongs_to :cover_photo, class_name: 'Photo'

  before_create :generate_slug

  scope :active, -> { where.not(cover_photo_id: nil) }

  def generate_slug
    self.slug = title.parameterize
  end
end
