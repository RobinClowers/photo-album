require "spec_helper"

describe GooglePhotos::Importer do
  let(:api) { double(:google_api) }
  let(:title) { "Sipadan 2018" }
  let(:slug) { "sipadan-2018" }
  let(:video_filename) { "VID_20181229_180357.mp4" }
  let(:first_filename) { filenames.first }
  let(:filenames) { ["IMG_20180703_103130.jpg", "IMG_20180703_103444.jpg", "IMG_20180705_181748.jpg"] }
  let(:first_google_id) { "AKkM_aJiYtFoRDZW0bGBLWONPTpmj4xh5gNN2f5UvMRGND_gIlWsUMAc46AcfnmwO4hH2MpWsVA_m-eSMU36FqXxa9-j8yi8IA" }
  let(:album) { Album.find_by_slug(slug) }
  let(:album_id) { "AKkM_aLGjbim7Z44iBgIBWy_2f8rY2G-q0aIuvlIHUzFqa4y2QNXbA0se4SoY-5CgDsLmHTYlEDM" }
  let(:google_auth) { Factory.create_google_auth }
  let(:importer) { GooglePhotos::Importer.new }
  let(:media_result_path) { Rails.root.join("spec", "fixtures", "files", "search_media_items_by_album.json") }
  let(:media_result) { JSON.parse(File.read(media_result_path)) }
  let(:download_response) { double(:download_response, status: 200, body: photo_file) }
  let(:photo_file) { Magick::Image.new(1,1).tap { |i| i.format = "jpg" }.to_blob }
  let(:processor) { double(:process_photos, process_images: nil, tmp_dir: tmp_dir) }
  let(:tmp_dir) { "tmp/photo_processing_test/#{album.slug}" }
  let(:uploader) { double(:uploader, upload: nil) }
  let(:album_response) { {
    "id": album_id,
    "title": "Sipadan 2018",
    "productUrl": "https://photos.google.com/lr/album/AKkM_aLGjbim7Z44iBgIBWy_2f8rY2G-q0aIuvlIHUzFqa4y2QNXbA0se4SoY-5CgDsLmHTYlEDM",
    "mediaItemsCount": "3",
    "coverPhotoBaseUrl": "https://lh3.googleusercontent.com/lr/AJ-EwvlcLEiW8UQ-VW3syNzRqI6RB8kO_utbHrK74F25NwHkpnoToTcFenKjdsBRRh4k24x_Rt7vjT0271VZ54aGK-CzkyCtgbugS9fTHCOcy7V7NhXe1QCTzfT73frKFNP5onojyDUQ3KoczoAnMrY9FedOlLfxCMW6rsPyC9Ds3KbNlbXJLCl8aZQlooUgbbK1TAasTi06JmY1hdXZkfjU8DBXJ7njPl-stkW7OHbmT7XbtNh2EqftMTr494eGbjRObirg5qtPSbW9mfmvH_0WOI45PgvvYT2dYgjo6Zj8Kr0gP6YqmIz3_2KkzT8mNaaj46G3VwBrkXgZ065kVoFcArMjVpjOwMFBjC4WgLyBdKyGo0uATtDw_zqQBX_CuydcxKUTbhNhUAc-_un2FhVJSP56RVgiFoz4EQjmeeEbsY65OsoCkf-sqt5IBpEQ4AQlits7Y3WKB4QPnpIgEtxHnmdX_-gAPzvX-0g5FH0tgdBPZSh8CyEWuVh_iFFdB-bTuDoilXTURk8SQT-nAa1dv0OnRenfydOxbyv62LBs4JyJ-kBn3erVqBePnxIhUjLzkEvjKnDStUzHk9_-C8lkkr4JuBBRXRS_0FIYbeLF7zFMVgGT9fpDLGL-1y_06YpjZNsTJrOFxpQE-Y3etz40qsbmYmcaN2qjtLQcTrqZfREhK2w_e52xCsEKbOy3UZaMTso",
    "coverPhotoMediaItemId": "AKkM_aJiYtFoRDZW0bGBLWONPTpmj4xh5gNN2f5UvMRGND_gIlWsUMAc46AcfnmwO4hH2MpWsVA_m-eSMU36FqXxa9-j8yi8IA"
  }.stringify_keys }

  before do
    allow(AlbumPhotos).to receive(:new) { api }
    allow(GooglePhotos::Api).to receive(:new) { api }
    allow(::ProcessPhotos).to receive(:new) { processor }
    allow(::Uploader).to receive(:new) { uploader }
    allow(api).to receive(:get_album) { album_response }
    allow(api).to receive(:search_media_items) { {
      "mediaItems": []
    } }
    allow(HTTP).to receive(:get) { download_response }
    allow(api).to receive(:search_media_items)
      .with(google_auth, {albumId: album_id, pageSize: 100}) { media_result }
  end


  describe "#import with new album" do
    before do
      importer.import(google_auth, album_id)
    end

    it "fetches album with correct params" do
      expect(api).to have_received(:get_album).with(google_auth, album_id)
    end

    it "adds the photos to the database" do
      expect(Album.first.photos.count).to eq(3)
    end

    it "searches with the expected params" do
      expect(api).to have_received(:search_media_items)
        .with(google_auth, {albumId: album_id, pageSize: 100, "pageToken" => nil})
    end

    it "uploads the files to s3" do
      expect(uploader).to have_received(:upload).exactly(3).times
      expect(uploader).to have_received(:upload)
        .with(tmp_dir, first_filename, PhotoSize.original, overwrite: false)
    end

    it "creates the photos in the database" do
      expect(Photo.first.filename).to eq(first_filename)
      expect(Photo.count).to eq(3)
    end

    it "skips video" do
      expect(Photo.exists?(filename: video_filename)).to be(false)
    end

    it "processes all the files" do
      expect(processor).to have_received(:process_images).with(filenames, force: false)
    end

    it "set the cover photo" do
      expect(album.cover_photo.google_id).to eq(media_result["coverPhotoMediaItemId"])
    end

    it "cleans up tmp dir" do
      expect(Dir.exist?(tmp_dir)).to be(false)
    end
  end

  describe "#import with existing items" do
    before do
      album = Album.create!(slug: slug, title: title)
      album.photos.create!(filename: first_filename, google_id: first_google_id)
      importer.import(google_auth, album_id)
    end

    it "processes only the new files" do
      expect(processor).to have_received(:process_images).with(filenames - [first_filename], force: false)
    end

    it "update captions for existing photo" do
      expect(Photo.first.caption).to eq("updated description")
    end

    it "only uploads new photos to s3" do
      expect(uploader).to have_received(:upload).exactly(2).times
    end

    it "creates new photos in the database" do
      expect(Photo.count).to eq(3)
    end
  end
end
