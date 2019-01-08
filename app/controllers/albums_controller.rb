class AlbumsController < ApplicationController
  respond_to :json

  expose(:album_list) { AlbumListQuery.new(current_user: current_user) }
  expose(:album) {
    AlbumQuery.new(slug: slug, album_list: album_list, current_user: current_user)
  }
  expose(:redirect) { Redirect.find_by_from(slug) }
  expose(:images) { album.photos.to_a }

  def index
    render json: album_list
  end

  def show
    redirect_to redirect.to if redirect
    render json: album
  end

  private

  def slug
    params[:id]
  end
end
