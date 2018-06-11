class AddMetadataToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :mime, :string
    add_column :photos, :google_id, :string
    add_column :photos, :taken_at, :datetime
    add_column :photos, :width, :integer
    add_column :photos, :height, :integer
    add_column :photos, :camera_make, :string
    add_column :photos, :camera_model, :string
    add_column :photos, :focal_length, :decimal
    add_column :photos, :aperture_f_number, :decimal
    add_column :photos, :iso_equivalent, :integer
  end
end
