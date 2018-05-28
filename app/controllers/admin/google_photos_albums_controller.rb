class Admin::GooglePhotosAlbumsController < Admin::ApplicationController
  def index
    resp = GoogleImporter.new.list(google_access_token_hash)
    render html: resp.html_safe
  end
end
