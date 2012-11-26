class AddOriginatingMessageIdToUserMessages < ActiveRecord::Migration
  def change
    add_column :user_messages, :originating_message_id, :integer
  end
end
