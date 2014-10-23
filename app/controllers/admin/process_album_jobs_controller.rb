class Admin::ProcessAlbumJobsController < Admin::ApplicationController
  def create
    ProcessPhotosWorker.perform_async(params['slug'])
    head :created
  end
end
