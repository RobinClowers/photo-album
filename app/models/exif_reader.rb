class ExifReader
  def self.extract_photo_model_data(magick_image)
    properties = magick_image.properties
    {
      aperture_f_number: fraction_to_float(properties["exif:MaxApertureValue"]),
      camera_make: properties["exif:Make"],
      camera_model: properties["exif:Model"],
      exposure_time: properties["exif:ExposureTime"],
      focal_length: fraction_to_float(properties["exif:FocalLength"]),
      height: properties["exif:ExifImageLength"],
      iso_equivalent: properties["exif:ISOSpeedRatings"],
      lat: to_coord_string(properties["exif:GPSLatitude"], properties["exif:GPSLatitudeRef"]),
      lon: to_coord_string(properties["exif:GPSLongitude"], properties["exif:GPSLongitudeRef"]),
      mime_type: magick_image.mime_type,
      taken_at: to_date(properties["exif:DateTime"]),
      width: properties["exif:ExifImageWidth"],
    }
  end

  def self.fraction_to_float(fraction)
    a, b = fraction.split("/")
    a.to_f / b.to_f
  end

  def self.to_coord_string(raw_coord, direction)
    return nil unless raw_coord
    degrees, minutes, seconds = raw_coord.split(", ")
    degrees = fraction_to_float(degrees)
    minutes = fraction_to_float(minutes)
    seconds = fraction_to_float(seconds)
    "#{degrees.to_i}° #{minutes.to_i}’ #{seconds}” #{direction}"
  end

  def self.to_date(string)
    DateTime.strptime(string, "%Y:%m:%d %H:%M:%S")
  end
end
