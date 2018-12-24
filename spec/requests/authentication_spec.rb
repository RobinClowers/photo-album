require "spec_helper"

RSpec.describe "POST /users/sign_in" do
  let(:user) { Factory.create_user }
  let(:url) { new_user_session_path }
  let(:headers) { RequestHelper.json_headers }
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
  let(:headers) { RequestHelper.json_headers }

  it "returns 204, no content" do
    delete(url, headers: headers)
    expect(response).to have_http_status(204)
  end
end
