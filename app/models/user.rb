class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :confirmable, :omniauthable, omniauth_providers: %i[facebook]

  attribute :profile_photo_url

  validates :provider, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
  end

  def signed_in?
    true
  end

  def profile_photo_url
    return nil unless uid
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
