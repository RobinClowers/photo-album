class Admin::ProcessVersionJobsController < Admin::ApplicationController
  def create
    if Photo::VALID_VERSIONS.include?(version)
      if album
        process_album(album)
      else
        Album.pluck(:slug).each do |slug|
          process_album(slug)
        end
      end
      head :created
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private

  def process_album(slug)
    ProcessAlbumWorker.perform_async(slug, [version])
  end

  def version
    @version ||= params[:version].to_sym
  end

  def album
    @album ||= params[:album]
  end
end
