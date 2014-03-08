require 'spec_helper'

describe Album do
  describe ".create" do
    it "generates a slug before saving" do
      Album.create!(title: 'Test Album')
      Album.last.slug.should eq 'test-album'
    end

    it "with a duplicate slug raises" do
      Album.create!(title: 'Test Album')
      expect {
        Album.create!(title: 'test album')
      }.to raise_error ActiveRecord::RecordNotUnique
    end
  end
end
