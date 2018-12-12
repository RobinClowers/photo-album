require "spec_helper"

describe ProcessPhotos do
  let(:album_photos) { double(:album_photos, upload: nil) }
  let(:uploader) { double(:uploader, upload: nil) }
  let(:album_processor) { double(:album_processor) }
  let(:filename) { "P1120375.JPG" }
  let(:slug) { "test-album" }
  let(:tmp_dir) { "tmp/photo_processing/#{slug}" }
  let(:mobile_size) { PhotoSize.mobile }
  subject(:processor) { ProcessPhotos.new(slug) }

  before do
    allow(AlbumPhotos).to receive(:new) { album_photos }
    allow(Uploader).to receive(:new) { uploader }
    allow(AlbumProcessor).to receive(:new) { album_processor }
    allow(FileUtils).to receive(:rm)
    allow(FileUtils).to receive(:rm_rf)
    allow(album_processor).to receive(:process)
    allow(album_photos).to receive(:original) { [filename] }
    allow(album_photos).to receive(:keys) { [] }
    allow(album_photos).to receive(:download_original).with(filename, tmp_dir)
    album = Album.create!(slug: slug)
    Photo.create!(filename: filename, album: album)
  end

  describe "#process(PhotoSize.all)" do
    before do
      processor.process_album
    end

    it "processes all photos" do
      expect(album_processor).to have_received(:process).once
        .with(Pathname.new(filename), sizes: PhotoSize.all, force: false)
    end

    it "uploads all versions" do
      expect(uploader).to have_received(:upload)
        .with(File.join(tmp_dir, "mobile"), filename, PhotoSize.mobile, overwrite: false)
      expect(uploader).to have_received(:upload)
        .with(File.join(tmp_dir, "tablet"), filename, PhotoSize.tablet, overwrite: false)
      expect(uploader).to have_received(:upload)
        .with(File.join(tmp_dir, "laptop"), filename, PhotoSize.laptop, overwrite: false)
      expect(uploader).to have_received(:upload)
        .with(File.join(tmp_dir, "desktop"), filename, PhotoSize.desktop, overwrite: false)
    end

    it "cleans up after itself" do
      expect(FileUtils).to have_received(:rm).with(File.join(tmp_dir, filename))
      expect(FileUtils).to have_received(:rm_rf).with(tmp_dir)
    end
  end

  describe "#process([:version])" do
    before do
      processor.process_album([mobile_size])
    end

    it "processes all photos" do
      expect(album_processor).to have_received(:process).once
        .with(Pathname.new(filename), sizes: [mobile_size], force: false)
    end

    it "uploads the specified version" do
      expect(uploader).to have_received(:upload)
        .with(File.join(tmp_dir, "mobile"), filename, mobile_size , overwrite: false)
    end

    it "cleans up after itself" do
      expect(FileUtils).to have_received(:rm).with(File.join(tmp_dir, filename))
      expect(FileUtils).to have_received(:rm_rf).with(tmp_dir)
    end
  end

  describe "#process([:version]) with existing photo" do
    before do
      allow(album_photos).to receive(:keys) { [filename] }
      processor.process_album([mobile_size])
    end

    it "skips existing photos" do
      expect(album_processor).not_to have_received(:process)
    end

    it "skip uploading the specified version" do
      expect(uploader).not_to have_received(:upload)
    end

    it "cleans up after itself" do
      expect(FileUtils).to have_received(:rm_rf).with(tmp_dir)
    end
  end

  describe "#process([:version], force: true) with existing photo" do
    before do
      allow(album_photos).to receive(:keys) { [filename] }
      processor.process_album([mobile_size], force: true)
    end

    it "processes all photos" do
      expect(album_processor).to have_received(:process).once
        .with(Pathname.new(filename), sizes: [mobile_size], force: true)
    end

    it "uploads the specified version" do
      expect(uploader).to have_received(:upload)
        .with(File.join(tmp_dir, "mobile"), filename, mobile_size, overwrite: true)
    end

    it "cleans up after itself" do
      expect(FileUtils).to have_received(:rm).with(File.join(tmp_dir, filename))
      expect(FileUtils).to have_received(:rm_rf).with(tmp_dir)
    end
  end
end
