require "oauth2"

class GooglePhotos::AuthorizationGateway
  GOOGLE_AUTH_BASE_PATH = "https://accounts.google.com"
  GOOGLE_TOKEN_BASE_PATH = "https://www.googleapis.com"
  GOOGLE_AUTH_PATH = "/o/oauth2/v2/auth"
  GOOGLE_TOKEN_PATH = "/oauth2/v4/token"
  SCOPE = "https://www.googleapis.com/auth/photoslibrary.readonly"

  def initialize
    @client_id = ENV["GOOGLE_CLIENT_ID"]
    @client_secret = ENV["GOOGLE_SECRET"]
  end

  def build_authorization_url(redirect_uri)
    client = OAuth2::Client.new(
      @client_id,
      @client_secret,
      site: GOOGLE_AUTH_BASE_PATH,
      authorize_url: GOOGLE_AUTH_PATH,
    )
    client.auth_code.authorize_url(
      redirect_uri: redirect_uri, scope: SCOPE, access_type: "offline")
  end

  def request_token(auth_code, redirect_uri)
    client = OAuth2::Client.new(
      @client_id,
      @client_secret,
      site: GOOGLE_TOKEN_BASE_PATH,
      token_url: GOOGLE_TOKEN_PATH,
    )
    token = client.auth_code.get_token(auth_code, redirect_uri: redirect_uri).to_hash
    build_hash(token)
  end

  def refresh_token(token_hash)
    client = OAuth2::Client.new(
      @client_id,
      @client_secret,
      site: GOOGLE_TOKEN_BASE_PATH,
      token_url: GOOGLE_TOKEN_PATH,
    )
    token = OAuth2::AccessToken.from_hash(client, token_hash)
    token = token.refresh!.to_hash
    build_hash(token)
  end

  private
  def build_hash(token)
    {
      scope: token["scope"],
      token_type: token["token_type"],
      expires_at: token[:expires_at],
      access_token: token[:access_token],
      refresh_token: token[:refresh_token],
    }
  end
end
