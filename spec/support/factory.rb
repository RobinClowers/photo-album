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

  def self.create_album(params = {})
    Album.create!(params.reverse_merge({
      title: "Test Album",
    }))
  end

  def self.create_photo(params = {})
    Photo.create!(params.reverse_merge({
      filename: "P1080110.JPG",
    }))
  end

  def self.create_comment(params = {})
    Comment.create!(params.reverse_merge({
      photo: create_photo,
      body: "example comment",
    }))
  end
end
