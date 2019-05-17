class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :confirmable, :omniauthable, omniauth_providers: %i[facebook]

  attribute :profile_photo_url

  validates :provider, :name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
  end

  def signed_in?
    true
  end

  def profile_photo_url
    if uid
      "https://graph.facebook.com/v3.2/#{uid}/picture"
    else
      gravatar = Digest::MD5::hexdigest(email.strip.downcase)
      "http://gravatar.com/avatar/#{gravatar}"
    end
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
