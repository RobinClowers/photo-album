class Admin::ProcessVersionJobsController < Admin::ApplicationController
  def create
    if Photo::VALID_VERSIONS.include?(version)
      Album.pluck(:slug).each do |slug|
        ProcessPhotosWorker.perform_async(slug, versions: [version])
      end
      head :created
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private

  def version
    @version ||= params[:version].to_sym
  end
end
