class Admin::GooglePhotosAlbumsController < Admin::ApplicationController
  expose(:albums) { all_albums }
  expose(:new_album) { Album.new }

  def index; end

  def create
    if google_id
      ImportGoogleAlbumWorker.perform_async(google_authorization.id, google_id, force)
      redirect_to admin_root_path, notice: "Album imported queued"
    else
      redirect_to admin_google_photos_albums_path, notice: "missing google album ID"
    end
  end

  private

  def google_id
    @google_id ||= params.require(:album)[:id]
  end

  def force
    !!params["force"]
  end

  def all_albums
    fetcher = GooglePhotos::PageFetcher.new
    fetcher.all({ pageSize: 50 }, item_key: "albums") { |fetchParams|
      GooglePhotos::Api.new.list(google_authorization, fetchParams)
    }
  end
end
