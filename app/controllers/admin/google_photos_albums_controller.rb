class Admin::GooglePhotosAlbumsController < Admin::ApplicationController
  expose(:albums) { GooglePhotos::Api.new.list(google_access_token_hash) }
  expose(:new_album) { Album.new }

  def index; end

  def create
    if google_id
      google_importer = GooglePhotos::Importer.new
      google_importer.import(google_access_token_hash, google_id)
      redirect_to admin_root_path, notice: "Album imported successfully"
    else
      redirect_to admin_google_photos_albums_path, notice: "missing google album ID"
    end
  end

  private

  def google_id
    @google_id ||= params.require(:album)[:id]
  end
end
