require 'spec_helper'

describe User do
  describe ".create" do
    it "duplicate password raises" do
      create_user(email: "a@b.com")
      expect {
        create_user(email: "a@b.com")
      }.to raise_error ActiveRecord::RecordNotUnique
    end
  end

  def create_user(attributes)
    attributes.reverse_merge!(
      provider: 'custom',
      password: 'pass',
      password_confirmation: 'pass'
    )
    User.create! attributes
  end
end
