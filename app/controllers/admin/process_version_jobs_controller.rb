class Admin::ProcessVersionJobsController < Admin::ApplicationController
  def create
    if Photo::VALID_VERSIONS.include?(version)
      if album
        if photo_filenames
          reject_request and return unless album_contains_all_photos
          ProcessPhotosWorker.perform_async(album, photo_filenames, [version])
        else
          process_album(album)
        end
      else
        Album.pluck(:slug).each do |slug|
          process_album(slug)
        end
      end
      head :created
    else
      reject_request
    end
  end

  private

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
    @photo_filenames ||= params[:photo_filenames].strip.split(",").map(&:strip)
  end

  def force
    @force ||= params[:force].present?
  end
end
