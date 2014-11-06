class AddPublishedAtToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :published_at, :datetime
    Album.connection.execute <<-SQL
      UPDATE albums
      SET published_at = created_at
    SQL
  end
end
