class AlbumsController < ApplicationController
  respond_to :json

  expose(:album_list) { AlbumListQuery.new(current_user: current_user) }
  expose(:album) { album_list.active.includes(
    { photos: :versions }, { cover_photo: :versions }).find_by_slug!(slug) }
  expose(:redirect) { Redirect.find_by_from(slug) }
  expose(:images) { album.photos.to_a }

  def index
    render json: album_list
  end

  def show
    redirect_to redirect.to if redirect
    render json: {
      user: current_user,
      album: album.as_json(include: [:photos, :cover_photo]),
    }
  end

  private

  def slug
    params[:id]
  end
end
