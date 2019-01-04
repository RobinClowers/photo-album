require "spec_helper"

RSpec.describe GooglePhotos::PageFetcher do
  subject(:fetcher) { GooglePhotos::PageFetcher.new }

  it "#all returns items from a single page" do
    source = Proc.new { |params|
      break nil unless params[:key] == "key"
      { items: [1, 2] }
    }
    result = fetcher.all({ key: "key" }, :items, :page, :next_page) { |params|
      source.call(params)
    }
    expect(result).to eq([1, 2])
  end

  it "#all returns all items from multiple pages" do
    source = Proc.new { |params|
      break nil unless params[:key] == "key"
      case params[:next_page]
        when nil then { items: [1, 2], page: 2 }
        when 2 then { items: [3, 4] }
      end
    }
    result = fetcher.all({ key: "key" }, :items, :page, :next_page) { |params|
      source.call(params)
    }
    expect(result).to eq([1, 2, 3, 4])
  end
end
