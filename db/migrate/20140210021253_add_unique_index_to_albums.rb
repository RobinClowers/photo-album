class AddUniqueIndexToAlbums < ActiveRecord::Migration
  def change
    add_index :albums, :title, unique: true
  end
end
