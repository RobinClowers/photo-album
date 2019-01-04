require "spec_helper"

RSpec.describe Photo::FilenameScrubber do
  subject(:scrubber) { Photo::FilenameScrubber }

  it "replaces dots with dashes" do
    expect(scrubber.scrub("PANO_20181218_104720.vr~2.wat.jpg"))
      .to eq("PANO_20181218_104720-vr~2-wat.jpg")
  end
end
