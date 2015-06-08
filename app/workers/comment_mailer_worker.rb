class CommentMailerWorker
  include Sidekiq::Worker

  def perform(photo_id, comment_id)
    comment = Comment.find(comment_id)
    UsersWhoCommentedOnPhotoQuery.execute(photo_id).each do |recipient|
      CommentMailer.created(recipient, comment).deliver_now
    end
  end
end
