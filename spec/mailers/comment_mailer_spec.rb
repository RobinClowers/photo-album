require "spec_helper"

RSpec.describe CommentMailer do
  describe "created" do
    let(:recipient) { Factory.create_user }
    let(:commenter) { Factory.create_user(email: "commenter@example.com") }
    let(:album) { Factory.create_album }
    let(:photo) { Factory.create_photo(album: album) }
    let(:comment) { Factory.create_comment(user: commenter, photo: photo) }
    let(:mail) { CommentMailer.created(recipient, comment) }

    it "renders the subject" do
      expect(mail.subject).to eql("#{commenter.name} also commented on a photo you commented on")
    end

    it "renders the receiver email" do
      expect(mail.to).to eql([recipient.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eql(["notifications@photos.robinclowers.com"])
    end

    it "includes comment author's name" do
      expect(mail.body.encoded).to include(commenter.name)
    end

    it "includes comment body" do
      expect(mail.body.encoded).to include(comment.body)
    end

    it "includes link" do
      expect(mail.body.encoded).to include(ClientUrl.photo_url(album.slug, photo.filename))
    end
  end
end
