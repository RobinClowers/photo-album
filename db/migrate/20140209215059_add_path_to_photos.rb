class AddPathToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :path, :string
  end
end
