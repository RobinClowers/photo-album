class PhotoVersion < ApplicationRecord
  VALID_SIZES = %w{web small thumb}

  belongs_to :photo, inverse_of: :photo_versions, required: true

  validates :size, presence: true, inclusion: { in: VALID_SIZES }
end
