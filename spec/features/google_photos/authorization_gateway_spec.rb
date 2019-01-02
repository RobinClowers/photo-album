require 'spec_helper'

RSpec.describe GooglePhotos::AuthorizationGateway do
  subject(:gateway) { GooglePhotos::AuthorizationGateway.new }
  let(:redirect_uri) { "http://localhost/auth" }

  describe "#build_authorization_url" do
    it "returns a valid url" do
      expect(gateway.build_authorization_url(redirect_uri)).to eq(
        "https://accounts.google.com/o/oauth2/v2/auth?client_id=268034760811-b8v9ktoi81gt5kivhv497jhqr7uth3m4.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%2Fauth&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fphotoslibrary.readonly"
      )
    end
  end

  describe "#request_token", :vcr do
    let(:auth_code) { "<AUTH_CODE>" }
    let(:redirect_uri) { admin_google_photos_authorizations_callback_url(host: "localhost:5000") }

    it "returns a token hash" do
      access_token = gateway.request_token(auth_code, redirect_uri)
      expect(access_token.to_hash).to include({
        "scope" => "https://www.googleapis.com/auth/photoslibrary.readonly",
        "token_type" => "Bearer",
        access_token: "<ACCESS_TOKEN>",
        refresh_token: nil,
      })
    end
  end
end
