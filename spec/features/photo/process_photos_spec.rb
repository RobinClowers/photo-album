require "spec_helper"

describe ProcessPhotos do
  let(:album_photos) { double(:album_photos, upload: nil) }
  let(:uploader) { double(:uploader, upload: nil) }
  let(:album_processor) { double(:album_processor) }
  let(:image) { double(:magick_image_list) }
  let(:filename) { "P1120375.JPG" }
  let(:slug) { "test-album" }
  let(:tmp_dir) { "tmp/photo_processing/#{slug}" }
  let(:mobile_size) { PhotoSize.mobile }
  let(:exif_data) { {
    aperture_f_number: 3.4453125,
    camera_make: "Panasonic",
    camera_model: "DMC-ZS40",
    focal_length: 4.3,
    height: "3672",
    iso_equivalent: 160,
    lat: "9° 27’ 3.49” N",
    lon: "100° 1’ 46.58” E",
    mime_type: "image/jpeg",
    taken_at: "2018-12-12T14:41:01-06:00",
    width: "4896",
  } }
  let!(:album) { Album.create!(slug: slug) }
  let!(:photo) { Photo.create!(filename: filename, album: album) }
  subject(:processor) { ProcessPhotos.new(slug) }

  before do
    allow(AlbumPhotos).to receive(:new) { album_photos }
    allow(Uploader).to receive(:new) { uploader }
    allow(AlbumProcessor).to receive(:new) { album_processor }
    allow(ExifReader).to receive(:extract_photo_model_data) { exif_data }
    allow(FileUtils).to receive(:rm)
    allow(FileUtils).to receive(:rm_rf)
    allow(File).to receive(:exists?) { true }
    allow(album_processor).to receive(:process) { |&block| block.call(image) }
    allow(album_photos).to receive(:original) { [filename] }
    allow(album_photos).to receive(:keys) { [] }
    allow(album_photos).to receive(:download_original).with(filename, tmp_dir)
  end

  describe "#process(PhotoSize.all)" do
    before do
      processor.process_album
    end

    it "processes all photos" do
      expect(album_processor).to have_received(:process).once
        .with(filename, sizes: PhotoSize.all, force: false)
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

    it "updates photo with exif data" do
      photo.reload
      expect(photo.aperture_f_number.to_f).to eq(3.4453125)
      expect(photo.camera_make).to eq("Panasonic")
      expect(photo.camera_model).to eq("DMC-ZS40")
      expect(photo.focal_length.to_f).to eq(4.3)
      expect(photo.height).to eq(3672)
      expect(photo.iso_equivalent).to eq(160)
      expect(photo.lat).to eq("9° 27’ 3.49” N")
      expect(photo.lon).to eq("100° 1’ 46.58” E")
      expect(photo.mime_type).to eq("image/jpeg")
      expect(photo.taken_at).to eq("2018-12-12T14:41:01-06:00")
      expect(photo.width).to eq(4896)
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
        .with(filename, sizes: [mobile_size], force: false)
    end

    it "uploads the specified version" do
      expect(uploader).to have_received(:upload)
        .with(File.join(tmp_dir, "mobile"), filename, mobile_size , overwrite: false)
    end

    it "writes the version to the database" do
      expect(photo.reload.photo_versions.first).not_to be_nil
      expect(photo.reload.photo_versions.first.size).to eq(mobile_size.name)
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

  describe "#process([:version]) when original is too small for given version" do
    before do
      allow(File).to receive(:exists?) { false }
      processor.process_album([mobile_size])
    end

    it "doesn't upload the version" do
      expect(uploader).not_to have_received(:upload)
    end

    it "doesn't write the version to the database" do
      expect(photo.reload.photo_versions).to be_empty
    end
  end

  describe "#process([:version], force: true) with existing photo" do
    before do
      allow(album_photos).to receive(:keys) { [filename] }
      processor.process_album([mobile_size], force: true)
    end

    it "processes all photos" do
      expect(album_processor).to have_received(:process).once
        .with(filename, sizes: [mobile_size], force: true)
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
