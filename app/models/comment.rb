class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo

  attribute :user_profile_photo_url
  attribute :user_name

  validates :body, presence: true

  def user_profile_photo_url
    self.user.profile_photo_url
  end

  def user_name
    self.user.name
  end
end
