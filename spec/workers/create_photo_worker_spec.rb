require "spec_helper"

describe CreatePhotoWorker do
  describe "#perform" do
    subject(:worker) { CreatePhotoWorker.new }
    let(:valid_attrs) { {
        "filename" => "test filename",
        "path" => "test path",
        "mime" => "image/jpeg",
        "google_id" => "test google ID",
        "taken_at" => Time.parse("2018-05-10T02:36:49Z"),
        "width" => 4032,
        "height" => 3024,
        "camera_make" => "Google",
        "camera_model" => "Pixel 2",
        "focal_length" => 4.442,
        "aperture_f_number" => 1.8,
        "iso_equivalent" => 105,
    } }

    it "creates a photo model with all fields" do
      worker.perform(valid_attrs)
      expect(Photo.first).to have_attributes(valid_attrs)
    end
  end
end
