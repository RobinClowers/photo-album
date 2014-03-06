class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :provider, presence: true

  def self.create_with_omniauth(auth)
    create!(
      provider: auth["provider"],
      uid: auth["uid"],
      name: auth["info"]["name"]
    )
  end
end
