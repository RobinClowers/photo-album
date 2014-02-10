class AddAlbumIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :album_id, :integer
    add_index :photos, :album_id
  end
end
