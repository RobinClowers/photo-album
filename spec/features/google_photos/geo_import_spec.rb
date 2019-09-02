require "spec_helper"

describe GooglePhotos::GeoImporter do
  let(:path) { Rails.root.join("spec", "fixtures", "files", "google_photos_metadata") }
  subject(:importer) { GooglePhotos::GeoImporter.new(path) }
  let(:photo_title) { "IMG_20190113_173110.jpg" }
  let(:metadata) { JSON.parse(File.read(File.join(path, "#{photo_title}.json"))) }

  describe "#import" do
    it "imports missing geo data for all json files at the given path" do
      photo = Photo.create!(filename: photo_title)
      importer.import
      photo.reload
      expect(photo.lat).to eq "15.663019444444444"
      expect(photo.lon).to eq "-96.51848888888888"
    end
  end

  describe "#set_geo_data" do
    it "skips photo with exisiting gps data when force is false" do
      photo = Photo.create!(filename: photo_title, lat: "1", lon: "2")
      importer.set_geo_data(metadata, force: false)
      photo.reload
      expect(photo.lat).to eq "1"
      expect(photo.lon).to eq "2"
    end

    it "sets geo data for photo with exisiting gps data when force is true" do
      photo = Photo.create!(filename: photo_title, lat: "1", lon: "2")
      importer.set_geo_data(metadata, force: true)
      photo.reload
      expect(photo.lat).to eq "15.663019444444444"
      expect(photo.lon).to eq "-96.51848888888888"
    end

    it "sets geo data for photo without existing data" do
      photo = Photo.create!(filename: photo_title)
      importer.set_geo_data(metadata, force: false)
      photo.reload
      expect(photo.lat).to eq "15.663019444444444"
      expect(photo.lon).to eq "-96.51848888888888"
    end
  end
end

