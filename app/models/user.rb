class User < ApplicationRecord
  has_secure_password validations: false

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
