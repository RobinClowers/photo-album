# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_15_003433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "cover_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.datetime "published_at"
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
    t.string "versions", default: [], null: false, array: true
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
    t.string "email", limit: 255
    t.string "password_digest", limit: 255
    t.string "uid", limit: 255
    t.string "provider", limit: 255
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "photo_versions", "photos"
end
