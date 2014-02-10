class Album < ActiveRecord::Base
  has_many :photos, inverse_of: :album
  belongs_to :cover_photo, class_name: 'Photo'

  scope :active, -> { where.not(cover_photo_id: nil) }
end
