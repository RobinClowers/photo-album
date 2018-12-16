require 'spec_helper'

describe User do
  describe ".create" do
    it "duplicate email raises" do
      create_user(email: "a@b.com")
      expect {
        create_user(email: "a@b.com")
      }.to raise_error(
        ActiveRecord::RecordInvalid,
        "Validation failed: Email has already been taken"
      )
    end
  end

  def create_user(attributes)
    attributes.reverse_merge!(
      provider: 'email',
      password: 'password',
      password_confirmation: 'password'
    )
    User.create! attributes
  end
end
