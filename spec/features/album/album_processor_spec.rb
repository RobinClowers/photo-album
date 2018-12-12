require "spec_helper"

describe AlbumProcessor do
  let(:base_path) { Rails.root.join("spec", "fixtures", "files", "photos") }
  let(:filename) { "P1120375.JPG" }
  let(:other_filename) { "P1080205.JPG" }
  let(:processed_filename) { "P1120375.jpg" }
  let!(:originals) { Dir.entries(base_path).select { |f| f =~ /\.jpg|png\Z/i } }
  let(:mobile_photo) { PhotoSize.mobile.photo_path(base_path, processed_filename) }
  let(:tablet_photo) { PhotoSize.tablet.photo_path(base_path, processed_filename) }
  let(:image) { double(:image).as_null_object }
  let(:mobile_geometry) { PhotoSize.mobile.geometry_string }
  let(:tablet_geometry) { PhotoSize.tablet.geometry_string }
  subject(:processor) { AlbumProcessor.new(base_path) }

  before do
    allow(PhotoSize).to receive(:all) { [PhotoSize.mobile, PhotoSize.tablet] }
  end

  def mock_image
    allow(Magick::ImageList).to receive(:new) { image }
    allow(image).to receive(:change_geometry) { image }
  end

  describe "#process all versions" do
    it "create the versions on disk" do
      processor.process(filename)
      expect(File.exists?(mobile_photo)).to be true
      expect(File.exists?(tablet_photo)).to be true
    end

    it "skips processed photos" do
      processor.create_versions(PhotoSize.mobile)
      mock_image
      processor.process(filename)
      expect(image).not_to have_received(:change_geometry).with(mobile_geometry)
      expect(image).to have_received(:change_geometry).with(tablet_geometry).once
    end

    it "resizes images for versions" do
      mock_image
      processor.process(filename)
      expect(image).to have_received(:change_geometry).with(mobile_geometry).once
      expect(image).to have_received(:change_geometry).with(tablet_geometry).once
    end
  end

  describe "#process a single version" do
    it "create the versions on disk" do
      processor.process(filename, sizes: [PhotoSize.mobile])
      expect(File.exists?(mobile_photo)).to be true
      expect(File.exists?(tablet_photo)).not_to be
    end

    it "skips processed photos" do
      processor.create_versions(PhotoSize.mobile)
      mock_image
      processor.process(filename, sizes: [PhotoSize.mobile])
      expect(image).not_to have_received(:change_geometry)
    end

    it "resizes images for versions" do
      mock_image
      processor.process(filename, sizes: [PhotoSize.mobile])
      expect(image).to have_received(:change_geometry).with(mobile_geometry).once
      expect(image).not_to have_received(:change_geometry).with(tablet_geometry)
    end
  end

  describe "#create_versions" do
    it "skips processed photos" do
      processor.create_versions(PhotoSize.mobile)
      mock_image
      processor.create_versions(PhotoSize.mobile)
      expect(image).not_to have_received(:change_geometry)
    end

    it "does not skip processed photos when force is true" do
      processor.create_versions(PhotoSize.mobile)
      mock_image
      processor.create_versions(PhotoSize.mobile, force: true)
      expect(image).to have_received(:change_geometry).with(mobile_geometry).twice
    end
  end

  after do
    FileUtils.remove_dir(PhotoSize.mobile.full_path(base_path), true)
    FileUtils.remove_dir(PhotoSize.tablet.full_path(base_path), true)
  end
end
