# This migration comes from pollett (originally 20150226024506)
class CreatePollettSessions < ActiveRecord::Migration
  def change
    create_table :pollett_sessions, id: :uuid, default: "uuid_generate_v1()" do |t|
      t.uuid :user_id, null: false
      t.string :token, null: false
      t.datetime :revoked_at
      t.datetime :accessed_at
      t.string :ip
      t.string :user_agent

      t.timestamps null: false
    end

    add_foreign_key :pollett_sessions, :users, on_delete: :cascade

    add_index :pollett_sessions, :user_id
    add_index :pollett_sessions, :token, unique: true
    add_index :pollett_sessions, :accessed_at
    add_index :pollett_sessions, :revoked_at
  end
end
