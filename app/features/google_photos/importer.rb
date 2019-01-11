class GooglePhotos::Importer
  def initialize(logger = Rails.logger)
    @logger = logger
  end

  def import(google_auth, google_album_id, force: false)
    @logger.info("fetching alubm")
    album_data = api.get_album(google_auth, google_album_id)
    @logger.info("Found #{album_data["title"]}")
    items = fetcher.all({ albumId: google_album_id, pageSize: 100 }) { |params|
      api.search_media_items(google_auth, params)
    }.reduce({}) { |result, item|
      filename = Photo::FilenameScrubber.scrub(item["filename"])
      item["scrubbed_filename"] = filename
      result[filename] = item
      result
    }
    @logger.info("Found #{items.count} photos")

    slug = ::AlbumSlug.new(album_data["title"])
    album = Album.find_or_create_by!(title: album_data["title"], slug: slug.to_s)
    processor = ::ProcessPhotos.new(slug)
    uploader = ::Uploader.new(slug)
    tmp_dir = processor.tmp_dir
    FileUtils.mkdir_p(tmp_dir) unless Dir.exists?(tmp_dir)

    existing_filenames = album.photos.where(filename: items.keys).pluck(:filename)
    existing, to_create = partition_items(items, existing_filenames)
    @logger.info("Skipping import of #{existing.count} files: #{existing_filenames.join(", ")}")
    to_create.each do |item|
      filename = item["scrubbed_filename"]
      full_path = File.join(tmp_dir, filename)
      @logger.info("Downloading #{item["filename"]}")
      download_item(item, full_path) unless File.exists?(full_path)
      @logger.info("Uploading #{filename}")
      uploader.upload(tmp_dir, filename, PhotoSize.original, overwrite: force)
      create_photo(item, filename, album)
    end
    @logger.info("Updating attribues on #{existing.count} photos")
    existing.each do |item|
      photo = Photo.find_by_filename(item["scrubbed_filename"])
      photo.update_attributes(caption: item["description"])
    end
    set_cover_photo(album, items, album_data["coverPhotoMediaItemId"])
    filenames_to_process = to_create.map { |item| item["scrubbed_filename"] }
    processor.process_images(filenames_to_process, force: force)
    FileUtils.rm_rf(tmp_dir)
  end

  private

  def partition_items(items, existing_filenames)
    items.reduce([[], []]) { |result, (filename, item)|
      existing, to_create = result
      if existing_filenames.include?(Photo::FilenameScrubber.scrub(filename))
        existing << item
      else
        to_create << item if photo?(item)
      end
      result
    }
  end

  def photo?(media_item)
    ["image/jpeg", "image/png"].include?(media_item["mimeType"])
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

  def photos_to_create(media_items)
  end

  def create_photo(media_item, filename, album)
    meta = media_item["mediaMetadata"]
    photo = Photo.create!(
      filename: filename,
      path: album.slug,
      album_id: album.id,
      caption: media_item["description"],
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
  rescue ActiveRecord::RecordNotUnique
    @logger.warn("Photo #{photo.filename} already exists")
  end

  def set_cover_photo(album, items, cover_photo_id)
    return unless cover_photo_id
    cover_photo = album.photos.where(google_id: cover_photo_id).first
    @logger.info("Setting cover photo #{cover_photo.filename}")
    album.update_attributes!(cover_photo: cover_photo)
  end

  def api
    @api ||= GooglePhotos::Api.new
  end

  def fetcher
    @fetcher ||= GooglePhotos::PageFetcher.new
  end
end
