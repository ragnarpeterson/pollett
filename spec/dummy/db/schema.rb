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

ActiveRecord::Schema.define(version: 20150210204911) do

  create_table "pollett_sessions", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.string   "token",       null: false
    t.datetime "revoked_at"
    t.datetime "accessed_at"
    t.string   "ip"
    t.string   "user_agent"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pollett_sessions", ["accessed_at"], name: "index_pollett_sessions_on_accessed_at"
  add_index "pollett_sessions", ["revoked_at"], name: "index_pollett_sessions_on_revoked_at"
  add_index "pollett_sessions", ["token"], name: "index_pollett_sessions_on_token", unique: true
  add_index "pollett_sessions", ["user_id"], name: "index_pollett_sessions_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "reset_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_token"], name: "index_users_on_reset_token", unique: true

end
