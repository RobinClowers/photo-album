class RemovePhotoVersions < ActiveRecord::Migration[5.2]
  def change
    remove_column :photos, :versions
  end
end
