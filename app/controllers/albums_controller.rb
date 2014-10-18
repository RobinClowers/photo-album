class AlbumsController < ApplicationController
  expose(:albums) { Album.active }
  expose(:album) { Album.find_by_slug!(params[:id]) }
  expose(:images) { album.photos.to_a }

  def index; end

  def show; end
end
