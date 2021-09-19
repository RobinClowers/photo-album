class GooglePhotos::Importer
  attr_accessor :google_auth, :google_album_id, :logger

  def initialize(google_auth, google_album_id, logger = Rails.logger)
    @google_auth = google_auth
    @google_album_id = google_album_id
    @logger = logger
  end

  def reprocess(filename, force: false)
    item = fetch_album_photos.find { |i|
      i["scrubbed_filename"] = scrub_filename(i["filename"])
      i["scrubbed_filename"] == filename
    }
    raise "photo #{filename} not found" unless item
    FileUtils.mkdir_p(tmp_dir) unless Dir.exists?(tmp_dir)

    download_photo(item, force)
    processor.process_images([filename], force: force)
    FileUtils.rm_rf(tmp_dir) unless ENV["KEEP_PHOTO_CACHE"]
  end

  def import(force: false)
    logger.info("fetching alubm")
    logger.info("Found #{album_data["title"]}")
    items = fetch_album_photos.reduce({}) { |result, item|
      merge_scrubbed_filename(result, item)
    }
    logger.info("Found #{items.count} photos")

    find_or_create_album
    FileUtils.mkdir_p(tmp_dir) unless Dir.exists?(tmp_dir)

    existing_filenames = album.photos.where(filename: items.keys).pluck(:filename)
    existing, to_create = partition_items(items, existing_filenames)
    logger.info("Skipping import of #{existing.count} files: #{existing_filenames.join(", ")}")
    to_create.each do |item|
      download_photo(item, force)
      upload_photo(item, force)
      create_and_process_photo(item, force)
    end
    logger.info("Updating attribues on #{existing.count} photos")
    existing.each do |item|
      photo = Photo.find_by_filename(item["scrubbed_filename"])
      photo.update(caption: item["description"])
    end
    set_cover_photo(album, album_data["coverPhotoMediaItemId"])
    album.update_first_photo_taken_at!
    FileUtils.rm_rf(tmp_dir)
  end

  private

  def fetch_album_photos
    fetcher.all({ albumId: google_album_id, pageSize: 100 }) { |params|
      api.search_media_items(google_auth, params)
    }
  end

  def download_photo(item, force)
    filename = item["scrubbed_filename"]
    full_path = File.join(tmp_dir, filename)
    logger.info("Downloading #{item["filename"]}")
    download_item(item, full_path) unless File.exists?(full_path)
  end

  def upload_photo(item, force)
    filename = item["scrubbed_filename"]
    logger.info("Uploading #{filename}")
    uploader.upload(tmp_dir, filename, PhotoSize.original, overwrite: false)
  end

  def create_and_process_photo(item, force)
    filename = item["scrubbed_filename"]
    create_photo(item, filename)
    processor.process_images([filename], force: force)
  end


  def scrub_filename(filename)
    Photo::FilenameScrubber.scrub(filename)
  end

  def merge_scrubbed_filename(result, item)
    filename = scrub_filename(item["filename"])
    item["scrubbed_filename"] = filename
    result[filename] = item
    result
  end

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

  def create_photo(media_item, filename)
    meta = media_item["mediaMetadata"]
    album.photos.create!(
      filename: filename,
      path: album.slug,
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
    logger.warn("Photo #{filename} already exists")
  end

  def set_cover_photo(album, cover_photo_id)
    return unless cover_photo_id
    cover_photo = album.photos.find_by_google_id(cover_photo_id)
    if cover_photo
      logger.info("Setting cover photo #{cover_photo.filename}")
      album.update!(cover_photo: cover_photo)
    else
      logger.warn("cover photo not found with ID: #{cover_photo_id}")
    end
  end

  def api
    @api ||= GooglePhotos::Api.new
  end

  def fetcher
    @fetcher ||= GooglePhotos::PageFetcher.new
  end

  def slug
    @slug ||= ::AlbumSlug.new(album_data["title"])
  end

  def album_data
    return @album_data if @album_data
    @album_data = api.get_album(google_auth, google_album_id)
    logger.info("Found #{@album_data["title"]}")
    @album_data
  end

  def processor
    @processor ||= ::ProcessPhotos.new(slug)
  end

  def tmp_dir
    @tmp_dir = processor.tmp_dir
  end

  def uploader
    @uploader ||= ::Uploader.new(slug)
  end

  def album
    @album ||= find_or_create_album
  end

  def find_or_create_album
    Album.find_or_create_by!(title: album_data["title"], slug: slug.to_s)
  end
end
