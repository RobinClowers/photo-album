class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :confirmable

  attribute :profile_photo_url

  validates :provider, :name, presence: true

  def signed_in?
    true
  end

  def profile_photo_url
    gravatar = Digest::MD5::hexdigest(email.strip.downcase)
    "http://gravatar.com/avatar/#{gravatar}"
  end

  class NullUser < User
    def admin?
      false
    end

    def signed_in?
      false
    end
  end
end
