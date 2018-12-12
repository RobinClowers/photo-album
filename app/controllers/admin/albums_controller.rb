require 'albums'
require 'album_creator'

class Admin::AlbumsController < Admin::ApplicationController
  expose(:potential_albums) { Albums.new.names - Album.pluck(:slug) }
  expose(:unpublished_albums) { Album.unpublished }
  expose(:new_album) { Album.new_from_slug(slug) }
  expose(:albums_options) { Album.pluck(:title, :slug) }
  expose(:versions) { PhotoSize.all.map { |size| size.name } }
  expose(:album_titles) { Album.pluck(:title) }

  def index; end

  def new; end

  def create
    if create_album
      redirect_to admin_root_path, notice: 'Album created successfully'
    else
      render :new
    end
  end

  def update
    album_creator.insert_all_photos
    render nothing: true, status: :ok
  end

  def error
    raise 'This is only a test...'
  end

  private

  def create_album
    return unless new_album.update_attributes(album_attributes)
    album_creator.insert_all_photos
    album_creator.update_cover_photo!(cover_photo_filename)
  end

  def album_creator
    @album_creator ||= AlbumCreator.new(album_attributes[:title])
  end

  def album_attributes
    params.require(:album).permit(:title, :slug)
  end

  def cover_photo
    Photo.find_by_filename(cover_photo_filename)
  end

  def cover_photo_filename
    return unless params[:album]
    params[:album][:cover_photo_filename]
  end

  def slug
    params[:slug] || params[:album][:slug]
  end
end
