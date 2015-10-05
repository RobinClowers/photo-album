class AddVersionsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :versions, :string, array: true, null: false, default: []
    Photo.connection.execute <<-SQL
      UPDATE photos
      SET versions = ARRAY['web', 'thumbs'];
    SQL
  end
end
