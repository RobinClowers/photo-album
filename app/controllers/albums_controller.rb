class AlbumsController < ApplicationController
  respond_to :html, :json

  expose(:albums) { AlbumsQuery.new(current_user).active }
  expose(:album) { album_relation.find_by_slug!(slug) }
  expose(:redirect) { Redirect.find_by_from(slug) }
  expose(:images) { album.photos.to_a }

  def index
    respond_with albums.as_json(include: :cover_photo)
  end

  def show
    redirect_to redirect.to if redirect
    respond_with album
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
