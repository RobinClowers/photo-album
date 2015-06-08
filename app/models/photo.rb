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
    if offline_dev?
      ''
    elsif secure
      'https://'
    else
      'http://'
    end
  end

  def base_path(secure: false)
    if offline_dev?
      ENV['OFFLINE_DEV_PATH']
    elsif secure
      Rails.application.config.base_secure_photo_url
    else
      Rails.application.config.base_photo_url
    end
  end

  # these methods should be in a presenter
  def alt
    caption || "Photo in the album #{album.title}"
  end

  def overlay_url
    # this should be generated using path helpers if possible
    File.join('/', 'albums', path, filename)
  end

  private
  def offline_dev?
    ENV['OFFLINE_DEV'] == 'true'
  end
end
