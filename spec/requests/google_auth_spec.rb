require "spec_helper"

RSpec.describe "GET /admin/google_photos_authorizations/new" do
  let(:path) { admin_new_google_photos_authorization_path }
  let(:user) { Factory.create_user }
  let(:admin) { Factory.create_user(admin: true) }

  it "redirects unauthenticated users to root path" do
    get(path)
    expect(response).to redirect_to(root_path)
  end

  it "returns 403 for unauthenticated xhr requests" do
    get(path, xhr: true)
    expect(response).to have_http_status(403)
  end

  it "redirects non-admin users to root path" do
    sign_in(user)
    get(path)
    expect(response).to redirect_to(root_path)
  end

  it "redirects to google auth url" do
    sign_in(admin)
    get(path)
    expect(response).to redirect_to(
      "https://accounts.google.com/o/oauth2/v2/auth?access_type=offline&client_id=268034760811-b8v9ktoi81gt5kivhv497jhqr7uth3m4.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Fwww.example.com%2Fadmin%2Fgoogle_photos_authorizations%2Fcallback&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fphotoslibrary.readonly"
    )
  end
end

RSpec.describe "GET /admin/google_photos_authorizations/callback" do
  let(:path) { admin_google_photos_authorizations_callback_path }
  let(:user) { Factory.create_user }
  let(:admin) { Factory.create_user(admin: true) }
  let(:auth_gateway) { double(:google_authorization_gateway, request_token: token_hash) }
  let(:token_hash) { {
    scope: "https://www.googleapis.com/auth/photoslibrary.readonly",
    token_type: "Bearer",
    expires_at: 1546539895,
    access_token: "access token",
    refresh_token: "refresh token",
  } }

  before do
    allow(GooglePhotos::AuthorizationGateway).to receive(:new) { auth_gateway }
  end

  it "redirects unauthenticated users to root path" do
    get(path)
    expect(response).to redirect_to(root_path)
  end

  it "returns 403 for unauthenticated xhr requests" do
    get(path, xhr: true)
    expect(response).to have_http_status(403)
  end

  it "redirects non-admin users to root path" do
    sign_in(user)
    get(path)
    expect(response).to redirect_to(root_path)
  end

  it "stores google access token hash in session" do
    sign_in(admin)
    get(path, params: { code: "1234"})
    expect(session[:google_access_token_hash]).to eq(token_hash)
  end

  it "creates a GoogleAuthorization model" do
    sign_in(admin)
    get(path, params: { code: "1234"})
    auth = GoogleAuthorization.first
    expect(auth.user_id).to eq(admin.id)
    expect(auth.access_token).to eq(token_hash[:access_token])
    expect(auth.refresh_token).to eq(token_hash[:refresh_token])
    expect(auth.token_type).to eq(token_hash[:token_type])
    expect(auth.expires_at).to eq(Time.at(token_hash[:expires_at]))
  end

  it "redirects to google photos album index" do
    sign_in(admin)
    get(path, params: { code: "1234"})
    expect(response).to redirect_to(admin_google_photos_albums_path)
  end
end
