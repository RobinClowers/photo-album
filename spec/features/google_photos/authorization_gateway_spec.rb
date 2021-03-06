require 'spec_helper'

RSpec.describe GooglePhotos::AuthorizationGateway do
  subject(:gateway) { GooglePhotos::AuthorizationGateway.new }
  let(:redirect_uri) { "http://localhost/auth" }

  describe "#build_authorization_url" do
    it "returns a valid url" do
      expect(gateway.build_authorization_url(redirect_uri)).to eq(
        "https://accounts.google.com/o/oauth2/v2/auth?access_type=offline&client_id=268034760811-b8v9ktoi81gt5kivhv497jhqr7uth3m4.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%2Fauth&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fphotoslibrary.readonly"
      )
    end
  end

  describe "#request_token", :vcr do
    let(:auth_code) { "<AUTH_CODE>" }
    let(:redirect_uri) { admin_google_photos_authorizations_callback_url(host: "localhost:5000") }

    it "returns a token hash" do
      expect(gateway.request_token(auth_code, redirect_uri)).to include({
        scope: "https://www.googleapis.com/auth/photoslibrary.readonly",
        token_type: "Bearer",
        access_token: "<ACCESS_TOKEN>",
        refresh_token: "<REFRESH_TOKEN>",
      })
    end
  end

  describe "#refresh_token", :vcr do
    let(:token_hash) { {
      scope: "https://www.googleapis.com/auth/photoslibrary.readonly",
      token_type: "Bearer",
      expires_at: 1546539895,
      access_token: "<OLD_ACCESS_TOKEN>",
      refresh_token: "<REFRESH_TOKEN>",
    } }

    it "returns a refreshed token hash" do
      expect(gateway.refresh_token(token_hash)).to include({
        scope: "https://www.googleapis.com/auth/photoslibrary.readonly",
        token_type: "Bearer",
        access_token: "<NEW_ACCESS_TOKEN>",
        refresh_token: "<REFRESH_TOKEN>",
      })
    end
  end
end
