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

  describe "#calculate" do
    it "works for fixed hieght" do
      width, height = PhotoSize.mobile_sm.calculate(4000, 3000)
      expect(width).to eq(640)
      expect(height).to eq(480)
    end

    it "works for fixed width" do
      width, height = PhotoSize.new("test", 640, :natural).calculate(4000, 3000)
      expect(width).to eq(640)
      expect(height).to eq(480)
    end

    it "works for origial" do
      width, height = PhotoSize.original.calculate(4000, 3000)
      expect(width).to eq(4000)
      expect(height).to eq(3000)
    end

    it "returns :invalid when width is greater than original" do
      width, height = PhotoSize.mobile_sm.calculate(639, 479)
      expect(width).to eq(:invalid)
      expect(height).to eq(:invalid)
    end

    it "returns :invalid when height is greater than original" do
      width, height = PhotoSize.new("test", :natural, 480).calculate(639, 479)
      expect(width).to eq(:invalid)
      expect(height).to eq(:invalid)
    end
  end
end
