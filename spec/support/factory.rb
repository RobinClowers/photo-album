module Factory
  def self.create_user(params = {})
    User.create!(params.reverse_merge({
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
      provider: "email",
      confirmed_at: DateTime.now
    }))
  end

  def self.create_photo(params = {})
    Photo.create!(params.reverse_merge({
      filename: "P1080110.JPG",
    }))
  end
end
