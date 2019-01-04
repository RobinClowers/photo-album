class GooglePhotos::Importer
  def import(google_auth, google_album_id, force: false)
    album_data = api.get_album(google_auth, google_album_id)
    items = fetcher.all({ albumId: google_album_id, pageSize: 100 }) { |params|
      api.search_media_items(google_auth, params)
    }

    slug = ::AlbumSlug.new(album_data["title"])
    album = Album.find_or_create_by!(title: album_data["title"], slug: slug.to_s)
    processor = ::ProcessPhotos.new(slug)
    uploader = ::Uploader.new(slug)
    tmp_dir = processor.tmp_dir
    FileUtils.mkdir_p(tmp_dir) unless Dir.exists?(tmp_dir)

    items.each do |item|
      next if log_if_existing_photo(item["filename"])
      full_path = File.join(tmp_dir, item["filename"])
      Rails.logger.info("Downloading #{item["filename"]}")
      download_item(item, full_path) unless File.exists?(full_path)
      Rails.logger.info("Uploading #{item["filename"]}")
      uploader.upload(tmp_dir, item["filename"], PhotoSize.original, overwrite: force)
      create_photo(item, album, album_data["coverPhotoMediaItemId"])
    end
    processor.process_album(force: force)
    FileUtils.rm_rf(tmp_dir)
  end

  private

  def log_if_existing_photo(filename)
    if Photo.find_by_filename(filename)
      Rails.logger.info("Photo #{filename} exists")
      true
    else
      false
    end
  end

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
    if cover_photo_id && photo.google_id == cover_photo_id
      Rails.logger.info("Setting cover photo #{photo.filename}")
      album.update_attributes!(cover_photo: photo)
    end
    photo
  end

  def api
    @api ||= GooglePhotos::Api.new
  end

  def fetcher
    @fetcher ||= GooglePhotos::PageFetcher.new
  end
end
