class ClientUrl
  def self.photo_url(album_slug, photo_filename)
    "#{ENV.fetch("FRONT_END_ROOT")}/albums/#{album_slug}/#{photo_filename}"
  end
end
