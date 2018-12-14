class GooglePhotos::Importer
  def import(token_hash, google_album_id, force: false)
    album_data = api.get_album(token_hash, google_album_id)
    items = api.search_media_items(token_hash, {album_id: google_album_id})

    slug = ::AlbumSlug.new(album_data["title"])
    album = Album.find_or_create_by!(title: album_data["title"], slug: slug.to_s)
    processor = ::ProcessPhotos.new(slug)
    uploader = ::Uploader.new(slug)
    tmp_dir = processor.tmp_dir
    FileUtils.mkdir_p(tmp_dir) unless Dir.exists?(tmp_dir)

    items.each do |item|
      full_path = File.join(tmp_dir, item["filename"])
      download_item(item, full_path) unless File.exists?(full_path)
      uploader.upload(tmp_dir, item["filename"], PhotoSize.original, overwrite: force)
      create_photo(item, album, album_data["coverPhotoMediaItemId"])
    end
    processor.process_album(force: force)
    FileUtils.rm_rf(tmp_dir)
  end

  private

  def download_item(item, full_path)
    download_url = "#{item["baseUrl"]}=d"
    response = HTTP.get(download_url)
    if response.status == 200
      open(full_path, "wb") do |file|
        file.write(response.body)
      end
    else
      raise "Error downloading image, #{response.body}"
    end
  end

  def create_photo(media_item, album, cover_photo_id)
    filename = media_item["filename"]
    if Photo.where(filename: filename).first
      Rails.logger.info("Photo #{filename} exists")
      return
    end

    raise unless album.id

    meta = media_item["mediaMetadata"]
    photo = Photo.create!(
      filename: filename,
      path: album.slug,
      album_id: album.id,
      caption: meta["description"],
      mime_type: media_item["mimeType"],
      google_id: media_item["id"],
      taken_at: meta["creationTime"],
      width: meta["width"],
      height: meta["height"],
      camera_make: meta["cameraMake"],
      camera_model: meta["cameraModel"],
      focal_length: meta["focalLength"],
      aperture_f_number: meta["apertureFNumber"],
      iso_equivalent: meta["isoEquivalent"],
    )
    photo.has_size!(
      PhotoSize.original,
      filename,
      media_item["mimeType"],
      meta["width"],
      meta["height"]
    )
    if cover_photo_id && photo.google_id == cover_photo_id
      Rails.logger.info("Setting cover photo #{photo.filename}")
      album.update_attributes!(cover_photo: photo)
    end
    photo
  end

  def api
    @api ||= GooglePhotos::Api.new
  end
end
