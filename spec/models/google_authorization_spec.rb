require 'spec_helper'

RSpec.describe GoogleAuthorization do
  let(:user) { Factory.create_user }

  it "stores encrypted access token" do
    auth = GoogleAuthorization.create!(user: user, access_token: "123")
    expect(auth.access_token).to eq("123")
    expect(auth.encrypted_access_token.length).to eq(29)
  end

  it "stores encrypted refresh token" do
    auth = GoogleAuthorization.create!(user: user, refresh_token: "abc")
    expect(auth.refresh_token).to eq("abc")
    expect(auth.encrypted_refresh_token.length).to eq(29)
  end
end
