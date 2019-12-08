class GoogleAuthorization < ApplicationRecord
  belongs_to :user, required: true

  attr_encrypted :access_token,
    # https://github.com/attr-encrypted/encryptor/issues/26#issuecomment-492215968
    key: ENV.fetch("ACCESS_TOKEN_ENCRYPTION_KEY").bytes[0..31].pack( "c" * 32 )
  attr_encrypted :refresh_token,
    key: ENV.fetch("REFRESH_TOKEN_ENCRYPTION_KEY").bytes[0..31].pack( "c" * 32 )

  def expired?
    expires_at <= Time.now
  end
end
