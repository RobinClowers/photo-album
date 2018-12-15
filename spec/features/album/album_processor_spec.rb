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
  let(:image) { double(:mini_magic_image, height: 75, width: 75) }
  let(:optimizer) { double(:image_optim, optimize_image!: nil) }
  let(:callback) { double(:callback, call: nil) }
  let(:tiny_geometry) { tiny_size.geometry_string }
  let(:little_geometry) { little_size.geometry_string }
  let(:little_size) { PhotoSize.new("little", 10, 10) }
  let(:tiny_size) { PhotoSize.new("tiny", 5, 5) }
  subject(:processor) { AlbumProcessor.new(base_path) }

  before do
    allow(PhotoSize).to receive(:all) { [little_size, tiny_size] }
    allow(ImageOptim).to receive(:new) { optimizer }
  end

  def mock_image
    allow(MiniMagick::Image).to receive(:open) { image }
    allow(image).to receive(:auto_orient) { image }
    allow(image).to receive(:resize) { image }
    allow(image).to receive(:interlace) { image }
    allow(image).to receive(:format) { image }
    allow(image).to receive(:write) { image }
    allow(image).to receive(:combine_options) do |&block|
      block.call(image)
    end
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
      processor.process(filename) do |size, filename, image|
        callback.call(size, filename, image)
      end
      expect(image).not_to have_received(:resize).with(tiny_geometry)
      expect(image).to have_received(:resize).with(little_geometry).once
      expect(callback).to have_received(:call).once
    end

    it "resizes each version" do
      mock_image
      processor.process(filename)
      expect(image).to have_received(:resize).with(tiny_geometry).once
      expect(image).to have_received(:resize).with(little_geometry).once
    end

    it "optimizes each version" do
      mock_image
      processor.process(filename)
      expect(optimizer).to have_received(:optimize_image!).with(tiny_photo).once
      expect(optimizer).to have_received(:optimize_image!).with(little_photo).once
    end

    it "does not process original images" do
      allow(PhotoSize).to receive(:all) { [PhotoSize.original] }
      mock_image
      processor.process(filename)
      expect(image).not_to have_received(:resize)
    end

    it "does not optimize originals" do
      allow(PhotoSize).to receive(:all) { [PhotoSize.original] }
      mock_image
      processor.process(filename)
      expect(optimizer).not_to have_received(:optimize_image!)
    end

    it "calls the callback for each version" do
      mock_image
      processor.process(filename) do |size, filename, image|
        callback.call(size, filename, image)
      end
      expect(callback).to have_received(:call)
        .with(tiny_size, processed_filename, image)
      expect(callback).to have_received(:call)
        .with(little_size, processed_filename, image)
    end

    it "calls the callback for original version with original filename" do
      allow(PhotoSize).to receive(:all) { [PhotoSize.original] }
      mock_image
      processor.process(filename) do |size, filename, image|
        callback.call(size, filename, image)
      end
      expect(callback).to have_received(:call)
        .with(PhotoSize.original, filename, image)
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
      expect(image).not_to have_received(:resize)
    end

    it "resizes images for versions" do
      mock_image
      processor.process(filename, sizes: [tiny_size])
      expect(image).to have_received(:resize).with(tiny_geometry).once
      expect(image).not_to have_received(:resize).with(little_geometry)
    end

    it "calls the callback for that version" do
      processor.process(filename, sizes: [tiny_size]) do |size, filename, image|
        callback.call(size, filename, image)
      end
      expect(callback).to have_received(:call).once
    end
  end

  describe "#create_versions" do
    it "skips processed photos" do
      processor.create_versions(tiny_size)
      mock_image
      processor.create_versions(tiny_size)
      expect(image).not_to have_received(:resize)
    end

    it "does not skip processed photos when force is true" do
      processor.create_versions(tiny_size)
      mock_image
      processor.create_versions(tiny_size, force: true)
      expect(image).to have_received(:resize).with(tiny_geometry).twice
    end

    it "does not create version wider than the original" do
      mock_image
      target_height = 50
      target_width = 100
      allow(image).to receive(:resize) { |&block|
        block.call(target_height, target_width)
      }
      allow(image).to receive(:height) { 75 }
      allow(image).to receive(:width) { 75 }
      processor.create_versions(PhotoSize.mobile_sm)
      expect(image).not_to have_received(:write)
    end

    it "does not create version taller than the original" do
      mock_image
      target_height = 100
      target_width = 50
      allow(image).to receive(:resize) {
        |&block| block.call(target_height, target_width)
      }
      allow(image).to receive(:height) { 75 }
      allow(image).to receive(:width) { 75 }
      processor.create_versions(PhotoSize.mobile_sm)
      expect(image).not_to have_received(:write)
    end

    it "calls the callback for each file" do
      processor.create_versions(tiny_size) do |size, filename, image|
        callback.call(size, filename, image)
      end
      expect(callback).to have_received(:call).twice
    end
  end

  after do
    FileUtils.remove_dir(tiny_size.full_path(base_path), true)
    FileUtils.remove_dir(little_size.full_path(base_path), true)
  end
end
