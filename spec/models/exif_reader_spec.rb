require "spec_helper"

describe ExifReader do
  describe ".extract_photo_model_data" do
    it "parses exif data for photo model" do
      path = Rails.root.join('spec', 'fixtures', 'files', 'photos', 'P1080205.JPG')
      image = Magick::ImageList.new(path)

      expect(ExifReader.extract_photo_model_data(image)).to eq({
        aperture_f_number: 3.4453125,
        camera_make: "Panasonic",
        camera_model: "DMC-ZS40",
        exposure_time: "10/10000",
        focal_length: 4.3,
        height: "3672",
        iso_equivalent: "160",
        lat: "9° 27’ 3.49” N",
        lon: "100° 1’ 46.58” E",
        mime_type: "image/jpeg",
        taken_at: "2017:01:27 17:55:53",
        width: "4896",
      })
    end

    it "handles empty gps coords" do
      path = Rails.root.join('spec', 'fixtures', 'files', 'photos', 'P1120375.JPG')
      image = Magick::ImageList.new(path)

      expect(ExifReader.extract_photo_model_data(image)).to eq({
        aperture_f_number: 3.44,
        camera_make: "Panasonic",
        camera_model: "DMC-FS15",
        exposure_time: "10/6400",
        focal_length: 5.2,
        height: "3000",
        iso_equivalent: "125",
        lat: nil,
        lon: nil,
        mime_type: "image/jpeg",
        taken_at: "2013:01:16 23:15:41",
        width: "4000",
      })
    end
  end

  it ".fraction_to_float produces a float from a fraction string" do
    expect(ExifReader.fraction_to_float("4442/1000")).to eq(4.442)
  end

  it ".to_coord_string produces a human readable coordinate string" do
    expect(ExifReader.to_coord_string("19/1, 24/1, 1848/100", "N"))
      .to eq("19° 24’ 18.48” N")
  end
end
