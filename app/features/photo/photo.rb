class Photo < ApplicationRecord
  belongs_to :album, inverse_of: :photos, optional: true
  has_many :versions, inverse_of: :photo, class_name: "PhotoVersion"
  has_many :comments, inverse_of: :photo
  has_many :favorites, inverse_of: :photo, class_name: "PlusOne"

  VALID_FILENAME_REGEX = /\.jpg|png\Z/i

  def has_version?(version)
    versions.where(name: version.name).any?
  end

  def has_size!(size, filename, mime_type, width, height)
    versions.create!(
      size: size.name,
      filename: filename,
      mime_type: mime_type,
      width: width,
      height: height
    )
  rescue ActiveRecord::RecordNotUnique
  end

  def original_version
    versions.find_by_size(PhotoSize.original.name) ||
      PhotoVersion::Nil.instance
  end

  def version_url(version)
    File.join(protocol, base_path, path, version.size, version.filename)
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

  def serializable_hash(options = {})
    super(options).merge!({
      versions: versions.map { |version| [version.size, version] }.to_h,
      urls: urls,
      alt: alt,
    })
  end

  def urls
    versions.map { |version| [version.size, version_url(version)] }.to_h
  end
end

class Photo::Nil < Photo
  def self.instance
    @instance ||= self.new
  end

  def url
    nil
  end

  def path
    nil
  end

  def version_url(version)
    nil
  end

  def filename
    nil
  end

  def alt
    nil
  end
end
