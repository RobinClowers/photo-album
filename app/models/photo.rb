class Photo < ActiveRecord::Base
  belongs_to :album, inverse_of: :photos

  default_scope -> { order(:filename) }

  def thumb_url
    File.join(Rails.application.config.base_photo_url, path, 'thumbs', filename)
  end

  def url
    File.join(Rails.application.config.base_photo_url, path, filename)
  end

  def insecure_url
    File.join("http://", Rails.application.config.base_photo_url, path, filename)
  end

  def secure_url
    File.join(Rails.application.config.base_secure_photo_url, path, filename)
  end
end
