class User < ActiveRecord::Base
  has_secure_password

  validates :provider, presence: true
end
