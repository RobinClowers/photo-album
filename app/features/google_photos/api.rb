class GooglePhotos::Api
  def list(google_auth)
    response = HTTP
      .auth(auth_header(google_auth))
      .get("https://photoslibrary.googleapis.com/v1/albums")
    if response.status == 401
      raise GoogleAuthenticationError.new("Failed to fetch albums", response)
    else
      JSON.parse(response.body.to_s)["albums"]
    end
  end

  def get_album(google_auth, id)
    response = HTTP
      .auth(auth_header(google_auth))
      .get("https://photoslibrary.googleapis.com/v1/albums/#{id}")
    if response.status == 401
      raise GoogleAuthenticationError.new("Failed to fetch album", response)
    else
      JSON.parse(response.body.to_s)
    end
  end

  def search_media_items(google_auth, params)
    Rails.logger.info("Searching media items with: #{params.to_json}")
    response = HTTP
      .auth(auth_header(google_auth))
      .post("https://photoslibrary.googleapis.com/v1/mediaItems:search",
            body: params.to_json)
    if response.status == 401
      raise GoogleAuthenticationError.new("Failed to search media items", response)
    else
      JSON.parse(response.body.to_s)["mediaItems"]
    end
  end

  private
  def auth_header(google_auth)
    raise GoogleAuthenticationError.new("Missing google authentication") unless google_auth
    "Bearer #{google_auth.access_token}"
  end
end
