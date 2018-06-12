class GooglePhotos::Api
  def list(token_hash)
    response = HTTP
      .auth(auth_header(token_hash))
      .get("https://photoslibrary.googleapis.com/v1/albums")
    if response.status == 401
      raise GoogleAuthenticationError.new("Failed to fetch albums", response)
    else
      JSON.parse(response.body.to_s)["albums"]
    end
  end

  def get_album(token_hash, id)
    response = HTTP
      .auth(auth_header(token_hash))
      .get("https://photoslibrary.googleapis.com/v1/albums/#{id}")
    if response.status == 401
      raise GoogleAuthenticationError.new("Failed to fetch album", response)
    else
      JSON.parse(response.body.to_s)
    end
  end

  def search_media_items(token_hash, params)
    Rails.logger.info("Searching media items with: #{params.to_json}")
    response = HTTP
      .auth(auth_header(token_hash))
      .post("https://photoslibrary.googleapis.com/v1/mediaItems:search",
            body: params.to_json)
    if response.status == 401
      raise GoogleAuthenticationError.new("Failed to search media items", response)
    else
      JSON.parse(response.body.to_s)["mediaItems"]
    end
  end

  private
  def auth_header(token_hash)
     raise GoogleAuthenticationError.new("Missing google api token") unless token_hash
    "Bearer #{token_hash["access_token"]}"
  end
end
