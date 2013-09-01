class AddMessageablesToMessagesAgain < ActiveRecord::Migration
  def change
    add_column :user_messages, :messageable_id, :integer
    add_column :user_messages, :messageable_type, :string
    add_index :user_messages, [:messageable_id, :messageable_type]
  end
end
