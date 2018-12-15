class AddUniqueContraintToPhotoVersions < ActiveRecord::Migration[5.2]
  def change
    add_index :photo_versions, [:photo_id, :size], unique: true
  end
end
