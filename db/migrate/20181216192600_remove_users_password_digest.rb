class RemoveUsersPasswordDigest < ActiveRecord::Migration[5.2]
  def change
    # This was never used, conflicts with devise
    remove_column :users, :password_digest, :string
  end
end
