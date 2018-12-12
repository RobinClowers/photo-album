require "spec_helper"

describe AlbumCreator do
  describe "#insert_all_photos" do
    let(:title) { "West Coast" }
    let(:photos) { double(:album_photos) }
    subject(:creator) { AlbumCreator.new(title) }

    before do
      allow(creator).to receive(:photos) { photos }
      allow(photos).to receive(:keys) { [] }
      allow(photos).to receive(:original) { [] }
    end

    it "inserts all valid photos" do
      allow(photos).to receive(:original) { ["1.png", "foo.txt", "2.png"] }
      album = Album.create(title: title)
      creator.insert_all_photos
      expect(Photo.count).to eq 2
      expect(Photo.first.path).to eq title.to_url
      expect(Photo.first.filename).to eq "1.png"
      expect(Photo.first.album).to eq album
    end

    it "inserts all valid photos" do
      allow(photos).to receive(:original) { ["1.png"] }
      allow(photos).to receive(:keys).with(PhotoSize.mobile) { ["1.png"] }
      allow(photos).to receive(:keys).with(PhotoSize.tablet) { ["2.png"] }
      allow(photos).to receive(:keys).with(PhotoSize.laptop) { ["1.png", "2.png"] }
      Album.create(title: title)
      creator.insert_all_photos
      expect(Photo.first.photo_versions.map(&:size)).to eq ["mobile", "laptop"]
    end

    it "creates the album when it doesn't exist" do
      allow(photos).to receive(:original) { ["1.png"] }
      creator.insert_all_photos
      expect(Album.count).to eq 1
      expect(Album.first.title).to eq title
    end
  end
end
