require 'spec_helper'

FakeResponse = Struct.new(:status, :body)

RSpec.describe GooglePhotos::Api do
  subject(:api) { GooglePhotos::Api.new }

  describe "#list refresh behavior" do
    let(:user) { Factory.create_user }
    let(:auth) { GoogleAuthorization.create!(
      user: user,
      scope: "https://www.googleapis.com/auth/photoslibrary.readonly",
      token_type: "Bearer",
      expires_at: 1546539895,
      access_token: "expired access token",
      refresh_token: "refresh token",
    ) }
    let(:refresh_token_hash) { {
      scope: "https://www.googleapis.com/auth/photoslibrary.readonly",
      token_type: "Bearer",
      expires_at: 1546539895,
      access_token: "access token",
      refresh_token: "refresh token",
    } }
    let(:unauthorized_http) { double(:http, get: FakeResponse.new(401)) }
    let(:authorized_http) { double(:http, get: FakeResponse.new(200, valid_response.to_json)) }
    let(:valid_response) { { "albums" => ["an album"] } }
    let(:fake_auth_gateway) { double(:google_photos_authorization_gateway) }
    let(:valid_auth_header) { "Bearer #{refresh_token_hash[:access_token]}" }

    before do
      allow(HTTP).to receive(:auth) { unauthorized_http }
      allow(HTTP).to receive(:auth).with(valid_auth_header)  { authorized_http }
      allow(GooglePhotos::AuthorizationGateway).to receive(:new) { fake_auth_gateway }
      allow(fake_auth_gateway).to receive(:refresh_token) { refresh_token_hash }
    end

    it "refreshes token on 401" do
      api.list(auth)
      expect(fake_auth_gateway).to have_received(:refresh_token)
    end

    it "retries and returns valid response" do
      expect(api.list(auth)).to eq(valid_response)
    end
  end
end
