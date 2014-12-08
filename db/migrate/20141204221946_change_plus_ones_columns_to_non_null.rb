class ChangePlusOnesColumnsToNonNull < ActiveRecord::Migration
  def change
    change_column :plus_ones, :user_id, :integer, null: false
    change_column :plus_ones, :photo_id, :integer, null: false
  end
end
