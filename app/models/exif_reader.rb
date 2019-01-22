class ExifReader
  def self.extract_photo_model_data(path)
    exif = Exiftool.new(path)
    {
      aperture_f_number: exif[:aperture],
      camera_make: exif[:make],
      camera_model: exif[:model],
      exposure_time: exif[:exposure_time].to_s,
      focal_length: exif[:focal_length],
      height: exif[:image_height],
      iso_equivalent: exif[:iso],
      lat: exif[:gps_latitude],
      lon: exif[:gps_longitude],
      mime_type: exif[:mime_type],
      taken_at: to_date(exif[:date_time_original]),
      width: exif[:image_width],
    }
  end

  def self.to_date(string)
    DateTime.strptime(string, "%Y:%m:%d %H:%M:%S")
  end
end
