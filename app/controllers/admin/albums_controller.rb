require 'albums'
require 'album_creator'

class Admin::AlbumsController < Admin::ApplicationController
  expose(:potential_albums) { Albums.new.names - Album.pluck(:slug) }
  expose(:unpublished_albums) { Album.unpublished }
  expose(:new_album) { CreateAlbum.new(slug: slug) }
  expose(:albums_options) { Album.pluck(:title, :slug) }
  expose(:versions) { PhotoSize.all.map { |size| size.name } }
  expose(:album_titles) { Album.pluck(:title) }

  def index; end

  def new; end

  def create
    if CreateAlbum.run(album_attributes)
      redirect_to admin_root_path, notice: 'Album created successfully'
    else
      render :new
    end
  end

  def update
    album_creator.insert_all_photos
    head :ok
  end

  def error
    raise 'This is only a test...'
  end

  private

  def album_creator
    @album_creator ||= AlbumCreator.new(album_attributes[:title])
  end

  def album_attributes
    params.require(:album).permit(:title, :slug, :cover_photo_filename)
  end

  def slug
    params[:slug] || params[:album][:slug]
  end
end
