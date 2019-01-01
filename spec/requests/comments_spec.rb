require 'spec_helper'

RSpec.describe "POST photos/:id/comments" do
  let(:user) { Factory.create_user }
  let(:photo) { Factory.create_photo }
  let(:path) { photo_comments_path(photo.id) }
  let(:params) { { comment: { body: "comment body" } } }

  it "redirects anonymous users" do
    post(path, params: params)
    expect(response).to redirect_to(new_user_session_path)
  end

  it "creates a comment" do
    sign_in(user)
    post(path, params: params)
    comment = Comment.first
    expect(comment).not_to be_nil
    expect(comment.body).to eq(params[:comment][:body])
    expect(comment.user_id).to eq(user.id)
  end

  it "sends comment emails" do
    sign_in(user)
    post(path, params: params)
    expect(CommentMailerWorker.jobs.size).to eq(1)
  end

  it "returns a 201" do
    sign_in(user)
    post(path, params: params)
    expect(response).to have_http_status(201)
  end
end
