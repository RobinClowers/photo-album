class GooglePhotos::PageFetcher
  def all(params, item_key = "mediaItems", page_key = "pageToken", next_page_key = "nextPageToken")
    items = []
    loop do
      result = yield(params)
      items.concat(result[item_key] || [])
      params[next_page_key] = result[page_key]
      break unless result[page_key]
    end
    items
  end
end
