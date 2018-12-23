require "spec_helper"

RSpec.describe "POST /users/sign_in" do
  let(:user) {
    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
      provider: "email",
      confirmed_at: DateTime.now
    )
  }
  let(:url) { new_user_session_path }
  let(:headers) {
    {
      "ACCEPT" => "application/json",
      "CONTENT_TYPE" => "application/json",
    }
  }
  let(:params) {
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  }

  it "returns 200 when login params are valid" do
    post(url, params: params.to_json, headers: headers)
    expect(response).to have_http_status(200)
  end

  it "returns unathorized status when login params are invalid" do
    post(url, headers: headers)
    expect(response).to have_http_status(401)
  end
end

RSpec.describe "DELETE /users/sign_out", type: :request do
  let(:url) { destroy_user_session_path }

  it "returns 204, no content" do
    delete(url, headers: headers)
    expect(response).to have_http_status(204)
  end
end
