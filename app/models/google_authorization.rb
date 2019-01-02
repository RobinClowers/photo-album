class GoogleAuthorization < ApplicationRecord
  belongs_to :user, required: true

  attr_encrypted :access_token, key: ENV.fetch("ACCESS_TOKEN_ENCRYPTION_KEY")
  attr_encrypted :refresh_token, key: ENV.fetch("REFRESH_TOKEN_ENCRYPTION_KEY")
end
