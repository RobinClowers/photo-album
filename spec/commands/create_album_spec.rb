require "spec_helper"

RSpec.describe CreateAlbum do
  let(:album_creator) { double(:album_creator) }
  let(:album) { Album.first }
  let!(:photo) { Factory.create_photo }

  describe ".run with valid params" do
    before do
      allow(AlbumCreator).to receive(:new) { album_creator }
      allow(album_creator).to receive(:insert_all_photos) {
        photo.update(album_id: album.id)
      }
      @result = CreateAlbum.run(slug: "test-slug", title: "Test", cover_photo_filename: photo.filename)
    end

    it "saves the album" do
      expect(@result.to_model).to eq(album)
    end

    it "errors are empty" do
      expect(@result.errors).to be_empty
    end

    it "inserts all photos to the database" do
      expect(album_creator).to have_received(:insert_all_photos)
    end

    it "saves with the correct slug" do
      expect(album.slug).to eq("test-slug")
    end

    it "saves with the correct cover photo" do
      expect(album.reload.cover_photo.filename).to eq(photo.filename)
    end
  end

  describe ".run with no params" do
    before do
      allow(AlbumCreator).to receive(:new) { album_creator }
      allow(album_creator).to receive(:insert_all_photos) {
        photo.update(album_id: album.id)
      }
      @result = CreateAlbum.run({})
    end

    it "returns errors" do
      expect(@result.errors.messages).to eq({
        slug: ["is required"],
        title: ["is required"],
        cover_photo_filename: ["is required"]
      })
      expect(@result.errors.details).to eq({
        slug: [{error: :missing}],
        title: [{error: :missing}],
        cover_photo_filename: [{error: :missing}]
      })
    end
  end
end
