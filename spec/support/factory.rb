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
end
