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

ActiveRecord::Schema[7.0].define(version: 2022_02_24_055112) do
  create_table "friendships", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.integer "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed"
    t.index ["receiver_id"], name: "index_friendships_on_receiver_id"
    t.index ["sender_id", "receiver_id"], name: "index_friendships_on_sender_id_and_receiver_id", unique: true
    t.index ["sender_id"], name: "index_friendships_on_sender_id"
  end

  create_table "links", force: :cascade do |t|
    t.datetime "expires"
    t.integer "user_id", null: false
    t.string "terms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "blacklist"
    t.string "post_url"
    t.string "post_thumbnail_url"
    t.string "post_description"
    t.datetime "last_ping", precision: nil
    t.integer "set_by_id"
    t.boolean "friends_only"
    t.string "last_ping_user_agent"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "past_links", force: :cascade do |t|
    t.integer "user_id"
    t.string "post_url"
    t.string "post_thumbnail_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "link_id"
    t.index ["link_id"], name: "index_past_links_on_link_id"
    t.index ["user_id"], name: "index_past_links_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "unique_emails", unique: true
    t.index ["username"], name: "unique_usernames", unique: true
  end

  add_foreign_key "friendships", "users", column: "receiver_id"
  add_foreign_key "friendships", "users", column: "sender_id"
  add_foreign_key "links", "users"
  add_foreign_key "links", "users", column: "set_by_id"
  add_foreign_key "past_links", "links", on_delete: :nullify
  add_foreign_key "past_links", "users"
end
