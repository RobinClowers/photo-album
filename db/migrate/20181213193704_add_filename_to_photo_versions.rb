class AddFilenameToPhotoVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :photo_versions, :filename, :string
  end
end
