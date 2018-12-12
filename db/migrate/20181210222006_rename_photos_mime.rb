class RenamePhotosMime < ActiveRecord::Migration[5.2]
  def change
    rename_column :photos, :mime, :mime_type
  end
end
