class Admin::PublishAlbumJobsController < Admin::ApplicationController
  def create
    Album.find_by_slug!(params[:slug]).publish!
    head :created
  end
end
