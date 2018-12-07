class Photos::CommentsController < ApplicationController
  before_action :require_signed_in, except: :index
  layout false

  expose(:comment) { Comment.new }
  expose(:comments) { Comment.where(photo_id: photo_id) }
  expose(:photo_id) { params[:photo_id] }

  def index
  end

  def create
    if comment.update_attributes(comment_params)
      CommentMailerWorker.perform_async(photo_id, comment.id)
      render json: { comment: comment }, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
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
