require "spec_helper"

RSpec.describe "POST /users" do
  let(:url) { user_registration_path }
  let(:headers) {
    {
      "ACCEPT" => "application/json",
      "CONTENT_TYPE" => "application/json",
    }
  }
  let(:params) {
    {
      user: {
        email: "test@example.com",
        name: "test-name",
        password: "password",
        password_confirmation: "password",
        provider: "email",
      }
    }
  }

  it "returns created status when registration params are valid" do
    post(url, params: params.to_json, headers: headers)
    expect(response).to have_http_status(201)
  end

  it "creates a user" do
    post(url, params: params.to_json, headers: headers)
    expect(User.first.name).to eq("test-name")
  end

  it "returns unprocessable status when registration params are invalid" do
    post(url, headers: headers)
    expect(response).to have_http_status(422)
  end
end
