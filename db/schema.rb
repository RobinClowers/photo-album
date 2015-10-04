# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150310215747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.integer  "cover_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",           limit: 255
    t.datetime "published_at"
  end

  add_index "albums", ["slug"], name: "index_albums_on_slug", unique: true, using: :btree
  add_index "albums", ["title"], name: "index_albums_on_title", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["photo_id"], name: "index_comments_on_photo_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "filename",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path",       limit: 255
    t.integer  "album_id"
    t.text     "caption"
    t.datetime "hidden_at"
  end

  add_index "photos", ["album_id"], name: "index_photos_on_album_id", using: :btree
  add_index "photos", ["path", "filename"], name: "index_photos_on_path_and_filename", unique: true, using: :btree

  create_table "plus_ones", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "photo_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plus_ones", ["photo_id", "user_id"], name: "index_plus_ones_on_photo_id_and_user_id", using: :btree
  add_index "plus_ones", ["user_id", "photo_id"], name: "index_plus_ones_on_user_id_and_photo_id", unique: true, using: :btree

  create_table "redirects", force: :cascade do |t|
    t.string   "from",       limit: 255
    t.string   "to",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redirects", ["from"], name: "index_redirects_on_from", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.string   "uid",             limit: 255
    t.string   "provider",        limit: 255
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                       default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
