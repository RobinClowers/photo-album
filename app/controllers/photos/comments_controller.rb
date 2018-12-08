class Photos::CommentsController < ApplicationController
  before_action :require_signed_in, except: :index
  layout false

  expose(:comment) { Comment.find_or_initialize_by(id: photo_id, user_id: current_user.id) }
  expose(:photo_id) { params[:photo_id] }

  def create
    if comment.update_attributes(comment_params)
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
