class CreatePhotoVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_versions do |t|
      t.string :size
      t.string :mime_type
      t.integer :width
      t.integer :height
      t.references :photo, foreign_key: true, index: true

      t.timestamps
    end
  end
end
