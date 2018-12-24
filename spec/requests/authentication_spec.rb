require "spec_helper"

RSpec.describe "POST /users/confirmation" do
  let(:user) { Factory.create_user(confirmed_at: nil) }
  let(:url) { user_confirmation_path }

  it "redirects to root when confirmation token is valid" do
    get(url, params: { confirmation_token: user.confirmation_token })
    expect(response).to redirect_to("http://localhost:3000/?emailConfirmed=true")
  end

  it "marks user confirmed when confirmation token is valid" do
    get(url, params: { confirmation_token: user.confirmation_token })
    expect(user.reload.confirmed?).to be(true)
  end

  it "redirects to root with error when the token is invalid" do
    user.confirm
    get(url, params: { confirmation_token: user.confirmation_token })
    expect(response).to redirect_to(
      "http://localhost:3000/?emailConfirmed=false&error=Email was already confirmed, please try signing in"
    )
  end
end

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
