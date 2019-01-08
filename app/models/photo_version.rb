class PhotoVersion < ApplicationRecord
  VALID_SIZES = PhotoSize.all.map(&:name)

  attribute :url

  belongs_to :photo, inverse_of: :versions, required: true

  validates :size, presence: true, inclusion: { in: VALID_SIZES }

  def url
    photo.version_url(self)
  end
end

class PhotoVersion::Nil < PhotoVersion
  def self.instance
    @instance ||= self.new
  end

  def url
    nil
  end

  def width
    nil
  end

  def height
    nil
  end

  def filename
    nil
  end
end
