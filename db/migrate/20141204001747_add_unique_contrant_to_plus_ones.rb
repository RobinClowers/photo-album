class AddUniqueContrantToPlusOnes < ActiveRecord::Migration
  def change
    remove_index :plus_ones, [:user_id, :photo_id]
    add_index :plus_ones, [:user_id, :photo_id], unique: true
  end
end
