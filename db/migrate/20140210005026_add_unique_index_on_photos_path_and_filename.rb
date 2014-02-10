class AddUniqueIndexOnPhotosPathAndFilename < ActiveRecord::Migration
  def change
    add_index :photos, [:path, :filename], unique: true
  end
end
