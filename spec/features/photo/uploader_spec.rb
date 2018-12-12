require "spec_helper"

describe Uploader do
  let(:path) { "spec/fixtures/files/photos/" }
  let(:full_path) { File.expand_path(path) }
  let(:filename) { "P1120375.JPG" }
  let(:other_filename) { "P1080205.JPG" }
  let(:all_filenames) { [filename, other_filename] }
  let(:filepath) { File.join(path, filename) }
  let(:slug) { AlbumSlug.new("new-album") }
  let(:album_photos) { double(:album_photos, keys: [], create: nil) }
  let(:size) { PhotoSize.mobile }
  subject(:uploader) { Uploader.new(slug) }

  before do
    allow(AlbumPhotos).to receive(:new).with(slug) { album_photos }
  end

  describe "#upload" do
    it "uploads the file" do
      uploader.upload(path, filename, size)
      expect(album_photos).to have_received(:create)
        .with(filename, File.join(full_path, filename), size, overwrite: false)
    end

    it "passes down the overwrite flag" do
      uploader.upload(path, filename, size, overwrite: true)
      expect(album_photos).to have_received(:create)
        .with(filename, File.join(full_path, filename), size, overwrite: true)
    end
  end

  describe "#upload_all" do
    it "uploads all files" do
      uploader.upload_all(path, size)
      expect(album_photos).to have_received(:create)
        .with(filename, File.join(full_path, filename), size, overwrite: false)
      expect(album_photos).to have_received(:create)
        .with(other_filename, File.join(full_path, other_filename), size, overwrite: false)
    end

    it "passes down the overwrite flag" do
      uploader.upload_all(path, size, overwrite: true)
      expect(album_photos).to have_received(:create)
        .with(filename, File.join(full_path, filename), size, overwrite: true)
    end

    it "skips existing_photos" do
      allow(album_photos).to receive(:keys).with(size) { all_filenames }
      uploader.upload_all(path, size)
      expect(album_photos).not_to have_received(:create)
    end

    it "doesn't skip existing_photos when overwrite is true" do
      allow(album_photos).to receive(:keys).with(size) { gll_filenames }
      uploader.upload_all(path, size, overwrite: true)
      expect(album_photos).to have_received(:create).twice
    end
  end
end
