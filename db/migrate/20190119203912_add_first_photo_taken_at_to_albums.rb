class AddFirstPhotoTakenAtToAlbums < ActiveRecord::Migration[5.2]
  def change
    add_column :albums, :first_photo_taken_at, :datetime
    add_index :albums, :first_photo_taken_at
  end
end
