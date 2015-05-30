class Photos::CommentsController < ApplicationController
  before_filter :require_signed_in, except: :index
  layout false

  expose(:comment) { Comment.new }
  expose(:comments) { Comment.where(photo_id: photo_id) }
  expose(:photo_id) { params[:photo_id] }

  def index
  end

  def create
    comment.update_attributes(comment_params)
    self.comment = Comment.new
    render 'index', status: :created
  end

  def destroy
    comment.destroy
    render 'index', status: :ok
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user, photo_id: photo_id)
  end
end
