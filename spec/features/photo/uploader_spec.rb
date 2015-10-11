require "spec_helper"

describe Uploader do
  let(:path) { "spec/fixtures/files/photos/" }
  let(:full_path) { File.expand_path(path) }
  let(:filename) { "P1120375.JPG" }
  let(:album_photos) { double(:album_photos, keys: [], create: nil) }
  subject(:uploader) { Uploader.new(path) }

  before do
    allow(AlbumPhotos).to receive(:new) { album_photos }
  end

  describe "#upload" do
    it "uploads the file" do
      uploader.upload(filename, :web)
      expect(album_photos).to have_received(:create)
        .with(filename, File.join(full_path, filename), type: :web)
    end

    it "raises for invalid types" do
      expect {
        uploader.upload(filename, :foo)
      }.to raise_error
    end
  end

  describe "#upload_all" do
    it "uploads all files" do
      uploader.upload_all(:web)
      expect(album_photos).to have_received(:create).once
        .with(filename, File.join(full_path, filename), type: :web)
    end

    it "skips existing_photos" do
      allow(album_photos).to receive(:keys).with(:web) { [filename] }
      uploader.upload_all(:web)
      expect(album_photos).not_to have_received(:create)
    end

    it "raises for invalid types" do
      expect {
        uploader.upload_all(:foo)
      }.to raise_error
    end
  end
end
