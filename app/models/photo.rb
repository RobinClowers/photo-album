class Photo < ActiveRecord::Base
  belongs_to :album, inverse_of: :photos

  default_scope -> { order(:filename) }

  def thumb_url
    File.join(protocol,base_path, path, 'thumbs', filename)
  end

  def url
    insecure_url
  end

  def insecure_url
    File.join(protocol, base_path, path, filename)
  end

  def secure_url
    File.join(protocol(secure: true), base_path(secure: true), path, filename)
  end

  def protocol(secure: false)
    if offline?
      ''
    elsif secure
      'https://'
    else
      'http://'
    end
  end

  def path
    if offline?
      super.titleize
    else
      super
    end
  end

  def base_path(secure: false)
    if offline?
      ENV['OFFLINE_PATH']
    elsif secure
      Rails.application.config.base_secure_photo_url
    else
      Rails.application.config.base_photo_url
    end
  end

  # this should be in a presenter
  def alt
    caption || "Photo in the album #{album.title}"
  end

  private
  def offline?
    ENV['OFFLINE'] == 'true'
  end
end
