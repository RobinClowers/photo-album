require "spec_helper"

describe PhotoSize do
  describe "#geometry_string" do
    it "mobile resizes to natural x 321" do
      geo = PhotoSize.mobile.geometry_string
      expect(geo).to eq("x321")
    end

    it "tablet resizes to natural x 576" do
      geo = PhotoSize.tablet.geometry_string
      expect(geo).to eq("x576")
    end

    it "laptop resizes to natural x 768" do
      geo = PhotoSize.laptop.geometry_string
      expect(geo).to eq("x768")
    end

    it "desktop resizes to natural x 1536" do
      geo = PhotoSize.desktop.geometry_string
      expect(geo).to eq("x1536")
    end
  end
end
