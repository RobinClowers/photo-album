require "spec_helper"

RSpec.describe AlbumListQuery do
  let!(:current_time) { Time.zone.now.change(usec: 0) }
  let(:admin) { Factory.create_admin }
  let(:user) { Factory.create_user }
  let(:album) { Factory.create_album(published_at: current_time) }
  let(:photo) { Factory.create_photo(album: album) }
  let(:version) { Factory.create_photo_version(photo: photo) }
  subject(:album_list) { AlbumListQuery.new(current_user: user) }

  before do
    Timecop.freeze(current_time)
    photo.update!(album: album)
    version
  end

 after do
    Timecop.return
 end

  describe "#as_json" do
    it "album with cover photo" do
      album.update(cover_photo: photo)
      album_list = AlbumListQuery.new(current_user: user)
      expect(album_list.as_json).to eq({
        user: user,
        albums: [album.as_json(include: :cover_photo)],
        share_photo: {
          url: version.url,
          width: version.width,
          height: version.height,
        },
      })
    end

    it "unpublished album for user" do
      album_list = AlbumListQuery.new(current_user: user)
      expect(album_list.as_json).to eq({
        user: user,
        albums: [],
        share_photo: {
          url: nil,
          width: nil,
          height: nil,
        },
      })
    end

    it "unpublished album for admin" do
      album_list = AlbumListQuery.new(current_user: admin)
      expect(album_list.as_json).to eq({
        user: admin,
        albums: [album.as_json(include: :cover_photo)],
        share_photo: {
          url: nil,
          width: nil,
          height: nil,
        },
      })
    end

    it "album without cover photo" do
      album_list = AlbumListQuery.new(current_user: admin)
      expect(album_list.as_json).to eq({
        user: admin,
        albums: [album.as_json(include: :cover_photo)],
        share_photo: {
          url: nil,
          width: nil,
          height: nil,
        },
      })
    end
  end
end
