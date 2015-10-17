class Admin::ProcessVersionJobsController < Admin::ApplicationController
  def create
    reject_request and return unless Photo::VALID_VERSIONS.include?(version)

    if album
      reject_request and return unless process_single_album
    else
      process_all_albums
    end

    head :created
  end

  private

  def process_single_album
    if photo_filenames
      return false unless album_contains_all_photos
      ProcessPhotosWorker.perform_async(album, photo_filenames, [version], force)
    else
      process_album(album)
    end
    true
  end

  def process_all_albums
    Album.pluck(:slug).each do |slug|
      process_album(slug)
    end
  end

  def reject_request
    render nothing: true, status: :unprocessable_entity
  end

  def album_contains_all_photos
    album_photos = Album.find_by_slug(album).photos.pluck(:filename)
    photo_filenames.all? { |filename| album_photos.include?(filename) }
  end

  def process_album(slug)
    ProcessAlbumWorker.perform_async(slug, [version])
  end

  def version
    @version ||= params[:version].to_sym
  end

  def album
    @album ||= params[:album]
  end

  def photo_filenames
    @photo_filenames ||= (params[:photo_filenames] || "").strip.split(",").map(&:strip).presence
  end

  def force
    @force ||= params[:force].present?
  end
end
