# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_19_203912) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "cover_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.datetime "published_at"
    t.datetime "first_photo_taken_at"
    t.index ["first_photo_taken_at"], name: "index_albums_on_first_photo_taken_at"
    t.index ["slug"], name: "index_albums_on_slug", unique: true
    t.index ["title"], name: "index_albums_on_title", unique: true
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["photo_id"], name: "index_comments_on_photo_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "google_authorizations", force: :cascade do |t|
    t.string "scope"
    t.string "token_type"
    t.string "encrypted_access_token"
    t.string "encrypted_access_token_iv"
    t.string "encrypted_refresh_token"
    t.string "encrypted_refresh_token_iv"
    t.datetime "expires_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["encrypted_access_token_iv"], name: "index_google_authorizations_on_encrypted_access_token_iv", unique: true
    t.index ["encrypted_refresh_token_iv"], name: "index_google_authorizations_on_encrypted_refresh_token_iv", unique: true
    t.index ["user_id"], name: "index_google_authorizations_on_user_id"
  end

  create_table "photo_versions", force: :cascade do |t|
    t.string "size"
    t.string "mime_type"
    t.integer "width"
    t.integer "height"
    t.bigint "photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filename"
    t.index ["photo_id", "size"], name: "index_photo_versions_on_photo_id_and_size", unique: true
    t.index ["photo_id"], name: "index_photo_versions_on_photo_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.string "filename", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "path", limit: 255
    t.integer "album_id"
    t.text "caption"
    t.string "mime_type"
    t.string "google_id"
    t.datetime "taken_at"
    t.integer "width"
    t.integer "height"
    t.string "camera_make"
    t.string "camera_model"
    t.decimal "focal_length"
    t.decimal "aperture_f_number"
    t.integer "iso_equivalent"
    t.string "exposure_time"
    t.string "lat"
    t.string "lon"
    t.index ["album_id"], name: "index_photos_on_album_id"
    t.index ["path", "filename"], name: "index_photos_on_path_and_filename", unique: true
  end

  create_table "plus_ones", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "photo_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["photo_id", "user_id"], name: "index_plus_ones_on_photo_id_and_user_id"
    t.index ["user_id", "photo_id"], name: "index_plus_ones_on_user_id_and_photo_id", unique: true
  end

  create_table "redirects", id: :serial, force: :cascade do |t|
    t.string "from", limit: 255
    t.string "to", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["from"], name: "index_redirects_on_from", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "uid", limit: 255
    t.string "provider", limit: 255
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "google_authorizations", "users"
  add_foreign_key "photo_versions", "photos"
end
