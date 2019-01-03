class CreateGoogleAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :google_authorizations do |t|
      t.string :scope
      t.string :token_type
      t.string :encrypted_access_token
      t.string :encrypted_access_token_iv
      t.string :encrypted_refresh_token
      t.string :encrypted_refresh_token_iv
      t.datetime :expires_at
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end

    add_index :google_authorizations, :encrypted_access_token_iv, unique: true
    add_index :google_authorizations, :encrypted_refresh_token_iv, unique: true
  end
end
