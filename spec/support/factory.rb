module Factory
  def self.create_user
    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
      provider: "email",
      confirmed_at: DateTime.now
    )
  end
end
