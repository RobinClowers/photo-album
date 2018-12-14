class PhotoVersion < ApplicationRecord
  VALID_SIZES = PhotoSize.all.map(&:name)

  belongs_to :photo, inverse_of: :photo_versions, required: true

  validates :size, presence: true, inclusion: { in: VALID_SIZES }
end
