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
  let(:auth_gateway) { double(:google_authorization_gateway, request_token: token) }
  let(:token_hash) { { token: "123" } }
  let(:token) { double(:oauth2_token_object, to_hash: token_hash) }

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

  it "stores google access token hash" do
    sign_in(admin)
    get(path, params: { code: "1234"})
    expect(session[:google_access_token_hash]).to eq(token_hash)
  end

  it "redirects to google photos album index" do
    sign_in(admin)
    get(path, params: { code: "1234"})
    expect(response).to redirect_to(admin_google_photos_albums_path)
  end
end
