require "spec_helper"

describe PhotoSize do
  describe "#geometry_string" do
    it "mobile_sm resizes to natural x 480" do
      geo = PhotoSize.mobile_sm.geometry_string
      expect(geo).to eq("x480")
    end

    it "mobile_lg resizes to natural x 960" do
      geo = PhotoSize.mobile_lg.geometry_string
      expect(geo).to eq("x960")
    end

    it "tablet resizes to natural x 1152" do
      geo = PhotoSize.tablet.geometry_string
      expect(geo).to eq("x1152")
    end

    it "laptop resizes to natural x 1535" do
      geo = PhotoSize.laptop.geometry_string
      expect(geo).to eq("x1535")
    end

    it "desktop resizes to natural x 2304" do
      geo = PhotoSize.desktop.geometry_string
      expect(geo).to eq("x2304")
    end
  end
end
