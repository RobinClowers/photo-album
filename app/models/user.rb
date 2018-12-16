class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :confirmable, :omniauthable
  has_secure_password validations: false

  attribute :profile_photo_url

  validates :provider, presence: true

  def self.create_with_omniauth(auth)
    create!(
      provider: auth["provider"],
      uid: auth["uid"],
      name: auth["info"]["name"],
      email: auth["info"]["email"]
    )
  end

  def signed_in?
    true
  end

  def profile_photo_url
    "https://graph.facebook.com/v2.3/#{uid}/picture"
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
