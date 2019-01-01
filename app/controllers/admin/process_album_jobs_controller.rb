class Admin::ProcessAlbumJobsController < Admin::ApplicationController
  def create
    if slug.blank?
      head :unprocessable_entity
    else
      ProcessAlbumWorker.perform_async(slug)
      head :created
    end
  end

  private

  def slug
    params[:slug] || params[:album][:slug]
  end
end
