class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :reply_to_id
      t.integer :tool_id
      t.boolean :acknowledged, default: false
      t.text :body
      t.timestamps
    end
  end
end
