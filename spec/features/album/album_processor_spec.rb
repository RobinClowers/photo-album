require "spec_helper"

describe AlbumProcessor do
  let(:base_path) { Rails.root.join("spec", "fixtures", "files", "photos") }
  let(:filename) { "P1120375.JPG" }
  let(:processed_filename) { "P1120375.jpg" }
  let(:other_filename) { "P1080205.JPG" }
  let(:processed_filename) { "P1120375.jpg" }
  let!(:originals) { Dir.entries(base_path).select { |f| f =~ /\.jpg|png\Z/i } }
  let(:little_photo) { little_size.photo_path(base_path, processed_filename) }
  let(:tiny_photo) { tiny_size.photo_path(base_path, processed_filename) }
  let(:image) { double(:image).as_null_object }
  let(:callback) { double(:callback, call: nil) }
  let(:tiny_geometry) { tiny_size.geometry_string }
  let(:little_geometry) { little_size.geometry_string }
  let(:little_size) { PhotoSize.new("little", 10, 10) }
  let(:tiny_size) { PhotoSize.new("tiny", 5, 5) }
  subject(:processor) { AlbumProcessor.new(base_path) }

  before do
    allow(PhotoSize).to receive(:all) { [little_size, tiny_size] }
  end

  def mock_image
    allow(Magick::ImageList).to receive(:new) { image }
    allow(image).to receive(:change_geometry) { image }
  end

  describe "#process all versions" do
    it "create the versions on disk" do
      processor.process(filename)
      expect(File.exists?(tiny_photo)).to be true
      expect(File.exists?(little_photo)).to be true
    end

    it "skips processed photos" do
      processor.create_versions(tiny_size)
      mock_image
      processor.process(filename) do |size, filename, mime_type|
        callback.call(size, filename, mime_type)
      end
      expect(image).not_to have_received(:change_geometry).with(tiny_geometry)
      expect(image).to have_received(:change_geometry).with(little_geometry).once
      expect(callback).to have_received(:call).once
    end

    it "resizes images for versions" do
      mock_image
      processor.process(filename)
      expect(image).to have_received(:change_geometry).with(tiny_geometry).once
      expect(image).to have_received(:change_geometry).with(little_geometry).once
    end

    it "calls the callback for each version" do
      processor.process(filename) do |size, filename, mime_type|
        callback.call(size, filename, mime_type)
      end
      expect(callback).to have_received(:call)
        .with(tiny_size, processed_filename, "image/jpeg")
      expect(callback).to have_received(:call)
        .with(little_size, processed_filename, "image/jpeg")
    end
  end

  describe "#process a single version" do
    it "create the versions on disk" do
      processor.process(filename, sizes: [tiny_size])
      expect(File.exists?(tiny_photo)).to be true
      expect(File.exists?(little_photo)).not_to be
    end

    it "skips processed photos" do
      processor.create_versions(tiny_size)
      mock_image
      processor.process(filename, sizes: [tiny_size])
      expect(image).not_to have_received(:change_geometry)
    end

    it "resizes images for versions" do
      mock_image
      processor.process(filename, sizes: [tiny_size])
      expect(image).to have_received(:change_geometry).with(tiny_geometry).once
      expect(image).not_to have_received(:change_geometry).with(little_geometry)
    end

    it "calls the callback for that version" do
      processor.process(filename, sizes: [tiny_size]) do |size, filename, mime_type|
        callback.call(size, filename, mime_type)
      end
      expect(callback).to have_received(:call).once
    end
  end

  describe "#create_versions" do
    it "skips processed photos" do
      processor.create_versions(tiny_size)
      mock_image
      processor.create_versions(tiny_size)
      expect(image).not_to have_received(:change_geometry)
    end

    it "does not skip processed photos when force is true" do
      processor.create_versions(tiny_size)
      mock_image
      processor.create_versions(tiny_size, force: true)
      expect(image).to have_received(:change_geometry).with(tiny_geometry).twice
    end

    it "does not create version wider than the original" do
      mock_image
      target_height = 50
      target_width = 100
      allow(image).to receive(:change_geometry) { |&block|
        block.call(target_height, target_width)
      }
      allow(image).to receive(:rows) { 75 }
      allow(image).to receive(:columns) { 75 }
      processor.create_versions(PhotoSize.mobile)
      expect(image).not_to have_received(:write)
    end

    it "does not create version taller than the original" do
      mock_image
      target_height = 100
      target_width = 50
      allow(image).to receive(:change_geometry) {
        |&block| block.call(target_height, target_width)
      }
      allow(image).to receive(:rows) { 75 }
      allow(image).to receive(:columns) { 75 }
      processor.create_versions(PhotoSize.mobile)
      expect(image).not_to have_received(:write)
    end

    it "calls the callback for each file" do
      processor.create_versions(tiny_size) do |size, filename, mime_type|
        callback.call(size, filename, mime_type)
      end
      expect(callback).to have_received(:call).twice
    end
  end

  after do
    FileUtils.remove_dir(tiny_size.full_path(base_path), true)
    FileUtils.remove_dir(little_size.full_path(base_path), true)
  end
end
