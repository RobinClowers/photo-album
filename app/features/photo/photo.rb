class Photo < ApplicationRecord
  belongs_to :album, inverse_of: :photos, optional: true
  has_many :photo_versions, inverse_of: :photo

  attribute :urls
  attribute :alt

  default_scope -> { order(:filename) }

  VALID_FILENAME_REGEX = /\.jpg|png\Z/i

  def has_version?(version)
    photo_versions.where(name: version.name).any?
  end

  def has_size!(size, filename, mime_type, width, height)
    photo_versions.create!(
      size: size.name,
      filename: filename,
      mime_type: mime_type,
      width: width,
      height: height
    )
  rescue ActiveRecord::RecordNotUnique
  end

  def version_url(version)
    File.join(protocol, base_path, path, version.size, version.filename)
  end

  def legacy_version_url(version)
    File.join(protocol, base_path, path, version.to_s, filename)
  end

  def thumb_url
    legacy_version_url(:thumbs)
  end

  def url
    File.join(protocol, base_path, path, filename)
  end

  def protocol(secure: true)
    if Rails.application.config.offline_dev
      'http://'
    elsif secure
      'https://'
    else
      'http://'
    end
  end

  def base_path(secure: false)
    if Rails.application.config.offline_dev
      "localhost:5000/#{ENV['OFFLINE_DEV_PATH']}"
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

  def versions
    photo_versions.map { |version| [version.size, version] }.to_h
  end

  def urls
    photo_versions.map { |version| [version.size, version_url(version)] }.to_h
  end
end
