require "http"

class GoogleImporter
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

  private
  def auth_header(token_hash)
    "Bearer #{token_hash["access_token"]}"
  end
end
