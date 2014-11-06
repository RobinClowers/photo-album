class AlbumsController < ApplicationController
  expose(:albums) { AlbumsQuery.new(current_user).active }
  expose(:album) { Album.find_by_slug!(slug) }
  expose(:redirect) { Redirect.find_by_from(slug) }
  expose(:images) { album.photos.to_a }

  def index; end

  def show
    redirect_to redirect.to if redirect
  end

  private

  def slug
    params[:id]
  end
end
