class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid, default: "uuid_generate_v1()" do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :reset_token

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_token, unique: true
  end
end
