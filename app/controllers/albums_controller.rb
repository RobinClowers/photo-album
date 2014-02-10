class AlbumsController < ApplicationController
  expose(:albums) { Album.active.to_a }
  expose(:images) { [] }

  def index; end

  def show; end
end
