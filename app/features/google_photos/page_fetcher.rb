class GooglePhotos::PageFetcher
  def all(params, item_key: "mediaItems", page_key: "pageToken", next_page_key: "nextPageToken")
    items = []
    loop do
      result = yield(params)
      items.concat(result[item_key] || [])
      params[page_key] = result[next_page_key]
      Rails.logger.info("page token: #{result[next_page_key]}")
      break unless result[next_page_key]
    end
    items
  end
end
