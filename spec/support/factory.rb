module Factory
  def self.create_user(params = {})
    User.create!(params.reverse_merge({
      email: "test@example.com",
      name: "Test User",
      password: "password",
      password_confirmation: "password",
      provider: "email",
      confirmed_at: DateTime.now
    }))
  end

  def self.create_admin(params = {})
    create_user(params.reverse_merge({
      email: "admin@example.com",
      admin: true,
    }))
  end

  def self.create_album(params = {})
    Album.create!(params.reverse_merge({
      title: "Test Album",
    }))
  end

  def self.create_photo(params = {})
    Photo.create!(params.reverse_merge({
      path: "test-album",
      filename: "P1080110.JPG",
    }))
  end

  def self.create_photo_version(params = {photo: create_photo})
    PhotoVersion.create!(params.reverse_merge({
      filename: "P1080110.JPG",
      size: PhotoSize.original.name,
      width: 4,
      height: 3,
    }))
  end

  def self.create_comment(params = {photo: create_photo})
    Comment.create!(params.reverse_merge({
      body: "example comment",
    }))
  end

  def self.create_google_auth(params = {user: create_admin})
    GoogleAuthorization.create!(params.reverse_merge({
      access_token: "access-token",
    }))
  end
end
