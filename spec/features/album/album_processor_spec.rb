require "spec_helper"

describe AlbumProcessor do
  let(:base_path) { Rails.root.join("spec", "fixtures", "files", "photos") }
  let(:web_path) { base_path.join("web") }
  let(:small_path) { base_path.join("small") }
  let(:thumb_path) { base_path.join("thumbs") }
  let!(:originals) { Dir.entries(base_path).select { |f| f =~ /\.jpg|png\Z/i } }
  let(:web_version_path) { web_path.join(originals.first) }
  let(:small_version_path) { small_path.join(originals.first) }
  let(:thumb_version_path) { thumb_path.join(originals.first) }
  let(:image) { double(:image).as_null_object }
  subject(:processor) { AlbumProcessor.new(base_path) }

  describe "#process_all" do
    def mock_image
      allow(Magick::ImageList).to receive(:new) { image }
      allow(image).to receive(:resize_to_fit) { image }
      allow(image).to receive(:resize_to_fill) { image }
    end

    it "create the versions on disk" do
      processor.process_all
      expect(File.exists?(web_version_path)).to be true
      expect(File.exists?(small_version_path)).to be true
      expect(File.exists?(thumb_version_path)).to be true
    end

    it "skips processed photos" do
      processor.create_versions(:web)
      processor.create_versions(:thumbs)
      mock_image
      processor.process_all
      expect(image).to have_received(:resize_to_fit).with(320, 320).once
      expect(image).not_to have_received(:resize_to_fill)
    end

    it "resizes images for versions" do
      mock_image
      processor.process_all
      expect(image).to have_received(:resize_to_fit).with(1024, 1024).once
      expect(image).to have_received(:resize_to_fit).with(320, 320).once
      expect(image).to have_received(:resize_to_fill).with(75, 75).once
    end

    after do
      FileUtils.remove_dir web_path
      FileUtils.remove_dir small_path
      FileUtils.remove_dir thumb_path
    end
  end
end
