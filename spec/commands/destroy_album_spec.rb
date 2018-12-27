require 'spec_helper'

describe DestroyAlbum, ".execute" do
  it "destroys photos, versions and album" do
    album = Album.create!(slug: "test")
    photo = album.photos.create!(filename: "test")
    photo.versions.create!(size: "mobile_sm")

    DestroyAlbum.execute(album.slug)

    expect(Album.count).to eq(0)
    expect(Photo.count).to eq(0)
    expect(PhotoVersion.count).to eq(0)
  end
end

