class Photo < ActiveRecord::Base
  belongs_to :album, inverse_of: :photos

  default_scope -> { order(:filename) }

  VALID_VERSIONS = [:web, :small, :thumbs, :original]
  VALID_FILENAME_REGEX = /\.jpg|png\Z/i

  def has_version?(version)
    versions.include? version.to_s
  end

  def has_version!(version)
    versions << version
    save!
  end

  def version_url(version)
    File.join(protocol, base_path, path, version.to_s, filename)
  end

  def thumb_url
    version_url(:thumbs)
  end

  def small_url
    version_url(:small)
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
    if Rails.application.config.offline_dev
      ''
    elsif secure
      'https://'
    else
      'http://'
    end
  end

  def base_path(secure: false)
    if Rails.application.config.offline_dev
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
end
