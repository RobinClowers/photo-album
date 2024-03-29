class Photos::CommentsController < ApplicationController
  before_action :authenticate_user!, except: :ndex
  layout false

  expose(:comment) { Comment.new(photo_id: photo_id, user_id: current_user.id) }
  expose(:photo_id) { params[:photo_id] }

  def create
    if comment.update(comment_params)
      CommentMailerWorker.perform_async(photo_id, comment.id)
      render json: { comment: comment }, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if comment.persisted?
      comment.destroy!
      render json: { ok: true }, status: :ok
    else
      render json: { errors: ["You are not authorized"] }, status: :forbidden
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user, photo_id: photo_id)
  end
end
