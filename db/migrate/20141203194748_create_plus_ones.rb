class CreatePlusOnes < ActiveRecord::Migration
  def change
    create_table :plus_ones do |t|
      t.integer :user_id
      t.integer :photo_id

      t.timestamps
    end

    add_index :plus_ones, [:photo_id, :user_id]
    add_index :plus_ones, [:user_id, :photo_id]
  end
end
