require "spec_helper"

RSpec.describe "POST /users/password" do
  let(:user) { Factory.create_user }
  let(:url) { user_password_path }
  let(:headers) { RequestHelper.json_headers }
  let(:params) {
    {
      user: {
        email: user.email,
      }
    }
  }

  before do
    post(url, params: params.to_json, headers: headers)
  end

  it "returns 201 when reset email is valid" do
    expect(response).to have_http_status(201)
  end

  it "sends change password instructions when email is valid" do
    mail = ActionMailer::Base.deliveries.first
    expect(mail.body.encoded).to match("Change my password")
  end
end

RSpec.describe "PATCH /users/password" do
  let(:user) { Factory.create_user }
  let(:url) { user_password_path }
  let(:headers) { RequestHelper.json_headers }
  let(:token) { user.send_reset_password_instructions }
  let(:new_password) { "asdfasdf1" }
  let(:params) {
    {
      user: {
        password: new_password,
        password_confirmation: new_password,
        reset_password_token: token,
      }
    }
  }

  before do
    patch(url, params: params.to_json, headers: headers)
  end

  it "returns 200 when the params are valid" do
    expect(response).to have_http_status(204)
  end

  it "updates the password when the params are valid" do
    expect(user.reload.valid_password?(new_password)).to be(true)
  end
end
