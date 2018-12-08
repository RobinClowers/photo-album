class AlbumsController < ApplicationController
  respond_to :json

  expose(:albums) { AlbumsQuery.new(current_user).active }
  expose(:album) { album_relation.find_by_slug!(slug) }
  expose(:redirect) { Redirect.find_by_from(slug) }
  expose(:images) { album.photos.to_a }

  def index
    render json: {
      user: current_user,
      albums: albums.includes(:cover_photo).as_json(include: :cover_photo),
    }
  end

  def show
    redirect_to redirect.to if redirect
    render json: {
      user: current_user,
      album: album.as_json(include: :photos),
    }
  end

  private

  def slug
    params[:id]
  end

  def album_relation
    if current_user.admin?
      Album
    else
      Album.active
    end
  end
end
