class Photo < ActiveRecord::Base
  belongs_to :album, inverse_of: :photos

  default_scope -> { order(:filename) }

  def thumb_url
    File.join(Rails.application.config.base_photo_url, path, 'thumbs', filename)
  end

  def url
    File.join(Rails.application.config.base_photo_url, path, filename)
  end
end
