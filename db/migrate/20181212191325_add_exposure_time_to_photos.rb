class AddExposureTimeToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :exposure_time, :string
  end
end
