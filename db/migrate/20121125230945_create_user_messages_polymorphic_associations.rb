class CreateUserMessagesPolymorphicAssociations < ActiveRecord::Migration
  def change
    remove_column :user_messages, :tool_id
    add_column :user_messages, :messageable_id, :integer
    add_column :user_messages, :messageable_type, :string
  end
end
