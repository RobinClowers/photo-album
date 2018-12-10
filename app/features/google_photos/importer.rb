class GooglePhotos::Importer
  def import(token_hash, google_album_id, force: false)
    album = api.get_album(token_hash, google_album_id)
    items = api.search_media_items(token_hash, {album_id: google_album_id})

    slug = ::AlbumSlug.new(album["title"])
    processor = ::ProcessPhotos.new(slug)
    uploader = ::Uploader.new(slug)
    tmp_dir = processor.tmp_dir
    FileUtils.mkdir_p(tmp_dir) unless Dir.exists?(tmp_dir)
    album = Album.find_or_create_by!(title: album["title"], slug: slug.to_s)

    items.each do |item|
      filename = "#{item["id"]}.jpg"
      full_path = File.join(tmp_dir, filename)
      download_item(item, full_path) unless File.exists?(full_path)
      uploader.upload(tmp_dir, filename, :original, overwrite: force)
      create_photo(item, album, filename)
    end
    processor.process_album(force: force)
    FileUtils.rm_rf(tmp_dir)
  end

  private

  def download_item(item, full_path)
    width = item["mediaMetadata"]["width"]
    height = item["mediaMetadata"]["height"]
    download_url = "#{item["baseUrl"]}=w#{width}-h#{height}"
    response = HTTP.get(download_url)
    if response.status == 200
      open(full_path, "wb") do |file|
        file.write(response.body)
      end
    else
      raise "Error downloading image, #{response.body}"
    end
  end

  def create_photo(media_item, album, filename)
    if Photo.where(filename: filename).first
      Rails.logger.info("Photo #{args.fetch("filename")} exists")
      return
    end
    meta = media_item["mediaMetadata"]
    Photo.create!(
      filename: filename,
      path: album.slug,
      album_id: album.id,
      caption: meta["description"],
      mime: media_item["mimeType"],
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
  end

  def api
    @api ||= GooglePhotos::Api.new
  end
end
