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

ActiveRecord::Schema.define(version: 20141113071519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: true do |t|
    t.string   "itunesid"
    t.string   "name"
    t.string   "artist"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_scraped"
    t.integer  "updatefreqhrs", default: 1
    t.string   "category"
    t.float    "price"
    t.string   "currency"
    t.string   "imageurl"
    t.string   "store_list",    default: [], array: true
    t.string   "version_list",  default: [], array: true
  end

  add_index "apps", ["itunesid"], name: "index_apps_on_itunesid", unique: true, using: :btree
  add_index "apps", ["updatefreqhrs"], name: "index_apps_on_updatefreqhrs", using: :btree

  create_table "rankings", force: true do |t|
    t.integer  "rank"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.datetime "pulldate"
    t.string   "store"
    t.integer  "change12hr"
    t.integer  "change24hr"
  end

  add_index "rankings", ["app_id"], name: "index_rankings_on_app_id", using: :btree
  add_index "rankings", ["category"], name: "index_rankings_on_category", using: :btree
  add_index "rankings", ["pulldate"], name: "index_rankings_on_pulldate", using: :btree
  add_index "rankings", ["store"], name: "index_rankings_on_store", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followedapp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followedapp_id"], name: "index_relationships_on_followedapp_id", using: :btree
  add_index "relationships", ["follower_id", "followedapp_id"], name: "index_relationships_on_follower_id_and_followedapp_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "app_id"
    t.datetime "updated"
    t.string   "title"
    t.text     "content"
    t.integer  "rating"
    t.string   "version"
    t.string   "author"
    t.string   "author_uri"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "store"
    t.integer  "itunesid",   limit: 8
  end

  add_index "reviews", ["app_id"], name: "index_reviews_on_app_id", using: :btree
  add_index "reviews", ["itunesid"], name: "index_reviews_on_itunesid", using: :btree
  add_index "reviews", ["store"], name: "index_reviews_on_store", using: :btree
  add_index "reviews", ["version"], name: "index_reviews_on_version", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.boolean  "gets_emails"
    t.string   "usertype",          default: "beta"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
