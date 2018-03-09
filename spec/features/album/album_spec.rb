require 'spec_helper'

describe Album do
  describe ".create" do
    let(:photo) { Photo.create! }

    it "generates a slug before saving" do
      Album.create!(title: 'Test Album', cover_photo: photo, photos: [photo])
      expect(Album.last.slug).to eq 'test-album'
    end

    it "with a duplicate slug raises" do
      Album.create!(title: 'Test Album', cover_photo: photo, photos: [photo])
      expect {
        Album.create!(title: 'test album', cover_photo: photo, photos: [photo])
      }.to raise_error ActiveRecord::RecordNotUnique
    end
  end
end
