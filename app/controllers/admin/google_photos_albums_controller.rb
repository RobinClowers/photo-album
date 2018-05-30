class Admin::GooglePhotosAlbumsController < Admin::ApplicationController
  expose(:albums) { GoogleImporter.new.list(google_access_token_hash) }

  def index; end
end
