class CommentMailer < ActionMailer::Base
  default from: "Robin's Photos Notifications <notifications@photos.robinclowers.com>"

  def created(recipient, comment)
    @recipient = recipient
    @comment = comment
    @photo = @comment.photo
    @album = @photo.album
    mail(
      to: @recipient.email,
      subject: "#{@comment.user.name} also commented on a photo you commented on",
    )
  end
end
