class Admin::ProcessAllAlbumsJobsController < Admin::ApplicationController
  def create
    ProcessAllAlbumsWorker.perform_async
    head :created
  end
end
