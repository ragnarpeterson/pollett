# This migration comes from pollett (originally 20150226024506)
class CreatePollettContexts < ActiveRecord::Migration
  def change
    create_table :pollett_contexts, id: :uuid do |t|
      t.string :type, null: false
      t.uuid :user_id, null: false
      t.string :client, null: false
      t.datetime :revoked_at
      t.datetime :accessed_at
      t.string :ip
      t.string :user_agent

      t.timestamps null: false
    end

    add_foreign_key :pollett_contexts, :users, on_delete: :cascade

    add_index :pollett_contexts, :user_id
    add_index :pollett_contexts, :accessed_at
    add_index :pollett_contexts, :revoked_at
  end
end
