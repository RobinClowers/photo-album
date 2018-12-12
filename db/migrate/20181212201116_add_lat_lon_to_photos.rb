class AddLatLonToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :lat, :string
    add_column :photos, :lon, :string
  end
end
