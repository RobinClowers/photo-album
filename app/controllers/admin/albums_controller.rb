require 'albums'

class Admin::AlbumsController < ApplicationController
  expose(:potential_albums) { Albums.new.names - Album.pluck(:slug) }

  def index; end
end
