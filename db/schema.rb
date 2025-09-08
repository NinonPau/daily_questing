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

ActiveRecord::Schema[7.1].define(version: 2025_09_08_124136) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_messages", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "chat_room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "chat_room_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_chat_rooms_on_creator_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "description"
    t.boolean "daily"
    t.boolean "completed"
    t.float "xp"
    t.boolean "duo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.boolean "ignored"
  end

  create_table "user_moods", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "mood_type", default: "Not selected"
    t.float "xp_bonus"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.float "total_xp"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chat_messages", "chat_rooms"
  add_foreign_key "chat_messages", "users"
  add_foreign_key "chat_room_users", "chat_rooms"
  add_foreign_key "chat_room_users", "users"
  add_foreign_key "chat_rooms", "users", column: "creator_id"
  add_foreign_key "friendships", "users"
  add_foreign_key "friendships", "users", column: "friend_id"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_moods", "users"
end
