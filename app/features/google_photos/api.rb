class GooglePhotos::Api
  def list(google_auth)
    execute_with_retry(google_auth) {
      response = HTTP
        .auth(auth_header(google_auth))
        .get("https://photoslibrary.googleapis.com/v1/albums")
      if response.status == 401
        raise GoogleAuthenticationError.new("Failed to fetch albums", response)
      else
        JSON.parse(response.body.to_s)["albums"]
      end
    }
  end

  def get_album(google_auth, id)
    execute_with_retry(google_auth) {
      response = HTTP
        .auth(auth_header(google_auth))
        .get("https://photoslibrary.googleapis.com/v1/albums/#{id}")
      if response.status == 401
        raise GoogleAuthenticationError.new("Failed to fetch album", response)
      else
        JSON.parse(response.body.to_s)
      end
    }
  end

  def search_media_items(google_auth, params)
    execute_with_retry(google_auth) {
      Rails.logger.info("Searching media items with: #{params.to_json}")
      response = HTTP
        .auth(auth_header(google_auth))
        .post("https://photoslibrary.googleapis.com/v1/mediaItems:search",
              body: params.to_json)
      if response.status == 401
        raise GoogleAuthenticationError.new("Failed to search media items", response)
      else
        JSON.parse(response.body.to_s)
      end
    }
  end

  private
  def auth_header(google_auth)
    raise GoogleAuthenticationError.new("Missing google authentication") unless google_auth
    "Bearer #{google_auth.access_token}"
  end

  def refresh_token(google_auth)
    token = GooglePhotos::AuthorizationGateway.new.refresh_token({
      scope: google_auth.scope,
      token_type: google_auth.token_type,
      expires_at: google_auth.expires_at,
      access_token: google_auth.access_token,
      refresh_token: google_auth.refresh_token,
    })
    google_auth.update_attributes!(
      scope: token[:scope],
      token_type: token[:token_type],
      expires_at: Time.at(token[:expires_at]),
      access_token: token[:access_token],
      refresh_token: token[:refresh_token],
    )
  end

  def execute_with_retry(google_auth)
    retries = 0
    begin
      yield
    rescue GoogleAuthenticationError
      if retries < 1
        Rails.logger.warn("GoogleAuthenticationError, refreshing token and retrying")
        refresh_token(google_auth)
        retries += 1
        retry
      else
        raise
      end
    end
  end
end
