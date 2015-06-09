class CommentMailerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :web

  def perform(photo_id, comment_id)
    comment = Comment.find(comment_id)
    users_to_email(photo_id, comment).each do |recipient|
      CommentMailer.created(recipient, comment).deliver_now
    end
  end

  def users_to_email(photo_id, comment)
    UsersWhoCommentedOnPhotoQuery
      .execute(photo_id)
      .reject { |recipient| comment.user == recipient }
  end
end
