class SetUsersConfirmedAt < ActiveRecord::Migration[5.2]
  def change
    User.where.not(uid: nil, provider: nil).update_all(confirmed_at: DateTime.now)
  end
end
