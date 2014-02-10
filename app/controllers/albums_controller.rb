class AlbumsController < ApplicationController
  expose(:albums) { Album.active }
  expose(:album)
  expose(:images) { album.photos.to_a }

  def index; end

  def show; end
end
