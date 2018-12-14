require "spec_helper"

describe ExifReader do
  describe ".extract_photo_model_data" do
    it "parses exif data for photo model" do
      path = Rails.root.join('spec', 'fixtures', 'files', 'photos', 'P1080205.JPG')

      expect(ExifReader.extract_photo_model_data(path)).to eq({
        aperture_f_number: 3.3,
        camera_make: "Panasonic",
        camera_model: "DMC-ZS40",
        exposure_time: "1/1000",
        focal_length: "4.3 mm",
        height: 75,
        iso_equivalent: 160,
        lat: 9.45096944,
        lon: 100.02960556,
        mime_type: "image/jpeg",
        taken_at: DateTime.parse("2017-01-27T17:55:53+00:00"),
        width: 75,
      })
    end

    it "handles empty gps coords" do
      path = Rails.root.join('spec', 'fixtures', 'files', 'photos', 'P1120375.JPG')

      expect(ExifReader.extract_photo_model_data(path)).to eq({
        aperture_f_number: 4,
        camera_make: "Panasonic",
        camera_model: "DMC-FS15",
        exposure_time: "1/640",
        focal_length: "5.2 mm",
        height: 75,
        iso_equivalent: 125,
        lat: nil,
        lon: nil,
        mime_type: "image/jpeg",
        taken_at: DateTime.parse("2013-01-16T23:15:41+00:00"),
        width: 75,
      })
    end
  end
end
