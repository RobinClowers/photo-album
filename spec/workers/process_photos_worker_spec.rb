require "spec_helper"

describe ProcessPhotosWorker do
  describe "#perform" do
    subject(:worker) { ProcessPhotosWorker.new }
    let(:album_title) { "title" }
    let(:photo_filenames) { ["1.jpg", "2.jpg"] }
    let(:tmp_dir) { "tmp/photo_processing_test/title/" }
    let(:processor) { double(:processor, process_images: nil, tmp_dir: tmp_dir) }

    before do
      allow(ProcessPhotos).to receive(:new).with(album_title) { processor }
    end

    it "processes all versions and doesn't force by default" do
      worker.perform(album_title, photo_filenames)
      expect(processor).to have_received(:process_images).
        with(photo_filenames, PhotoSize.all, force: false)
    end

    it "passes down versions and the force flag" do
      worker.perform(album_title, photo_filenames, ['tablet'], true)
      expect(processor).to have_received(:process_images).
        with(photo_filenames, [PhotoSize.tablet], force: true)
    end

    it "cleans up tmp dir" do
      expect(Dir.exist?(processor.tmp_dir)).to be(false)
    end
  end
end
