require "spec_helper"

describe AlbumProcessor do
  let(:base_path) { Rails.root.join("spec", "fixtures", "files", "photos") }
  let(:filename) { "P1120375.JPG" }
  let(:web_path) { base_path.join("web") }
  let(:small_path) { base_path.join("small") }
  let(:thumbs_path) { base_path.join("thumbs") }
  let!(:originals) { Dir.entries(base_path).select { |f| f =~ /\.jpg|png\Z/i } }
  let(:web_version_path) { web_path.join(originals.first) }
  let(:small_version_path) { small_path.join(originals.first) }
  let(:thumbs_version_path) { thumbs_path.join(originals.first) }
  let(:image) { double(:image).as_null_object }
  let(:web_proc) { double(:web_proc, call: image) }
  let(:small_proc) { double(:web_proc, call: image) }
  let(:versions) { { web: web_proc, small: small_proc } }
  subject(:processor) { AlbumProcessor.new(base_path) }

  def mock_image
    stub_const("AlbumProcessor::VERSIONS", versions)
    stub_const("Photo::VALID_VERSIONS", versions.keys)
    allow(Magick::ImageList).to receive(:new) { image }
    allow(image).to receive(:resize_to_fit) { image }
    allow(image).to receive(:resize_to_fill) { image }
  end

  describe "#process_all" do
    it "create the versions on disk" do
      processor.process_all
      expect(File.exists?(web_version_path)).to be true
      expect(File.exists?(small_version_path)).to be true
      expect(File.exists?(thumbs_version_path)).to be true
    end

    it "skips processed photos" do
      processor.create_versions(:web)
      mock_image
      processor.process_all
      expect(small_proc).to have_received(:call).with(image).once
    end

    it "resizes images for versions" do
      mock_image
      processor.process_all
      expect(web_proc).to have_received(:call).with(image).once
      expect(small_proc).to have_received(:call).with(image).once
    end
  end

  describe "#process" do
    it "create the versions on disk" do
      processor.process(filename)
      expect(File.exists?(web_version_path)).to be true
      expect(File.exists?(small_version_path)).to be true
      expect(File.exists?(thumbs_version_path)).to be true
    end

    it "skips processed photos" do
      processor.create_versions(:web)
      mock_image
      processor.process(filename)
      expect(small_proc).to have_received(:call).with(image).once
    end

    it "resizes images for versions" do
      mock_image
      processor.process(filename)
      expect(web_proc).to have_received(:call).with(image).once
      expect(small_proc).to have_received(:call).with(image).once
    end
  end

  describe "#create_versions" do
    it "skips processed photos" do
      processor.create_versions(:web)
      mock_image
      processor.create_versions(:web)
      expect(web_proc).not_to have_received(:call)
    end

    it "does not skip processed photos when force is true" do
      processor.create_versions(:web)
      mock_image
      processor.create_versions(:web, force: true)
      expect(web_proc).to have_received(:call).with(image)
    end
  end

  describe "::VERSIONS" do
    subject(:versions) { AlbumProcessor::VERSIONS }

    it "web resizes to fit" do
      versions[:web].call(image)
      expect(image).to have_received(:resize_to_fit).with(1024, 1024)
    end

    it "small resizes to fill" do
      versions[:small].call(image)
      expect(image).to have_received(:resize_to_fill).with(240, 240)
    end

    it "thumbs resizes to fill" do
      versions[:thumbs].call(image)
      expect(image).to have_received(:resize_to_fill).with(75, 75)
    end
  end

  after do
    FileUtils.remove_dir web_path if File.exists? web_path
    FileUtils.remove_dir small_path if File.exists? small_path
    FileUtils.remove_dir thumbs_path if File.exists? thumbs_path
  end
end
