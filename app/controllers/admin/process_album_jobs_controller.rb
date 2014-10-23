class Admin::ProcessAlbumJobsController < ApplicationController
  def create
    ProcessPhotosWorker.perform_async(params['slug'])
    head :created
  end
end
