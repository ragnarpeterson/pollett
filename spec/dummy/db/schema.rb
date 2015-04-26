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

ActiveRecord::Schema.define(version: 20150226030316) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "pollett_contexts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "type",        null: false
    t.uuid     "user_id",     null: false
    t.string   "client",      null: false
    t.datetime "revoked_at"
    t.datetime "accessed_at"
    t.string   "ip"
    t.string   "user_agent"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pollett_contexts", ["accessed_at"], name: "index_pollett_contexts_on_accessed_at", using: :btree
  add_index "pollett_contexts", ["revoked_at"], name: "index_pollett_contexts_on_revoked_at", using: :btree
  add_index "pollett_contexts", ["user_id"], name: "index_pollett_contexts_on_user_id", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "reset_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_token"], name: "index_users_on_reset_token", unique: true, using: :btree

  add_foreign_key "pollett_contexts", "users", on_delete: :cascade
end
