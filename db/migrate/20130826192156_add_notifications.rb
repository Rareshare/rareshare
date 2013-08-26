class AddNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer  :user_id
      t.integer  :notifiable_id
      t.string   :notifiable_type
      t.datetime :seen_at
      t.hstore   :properties
      t.timestamps
    end

    # New notifications by user
    add_index :notifications, [:user_id, :seen_at]

    # Recent notifications by user
    add_index :notifications, [:user_id, :created_at]

    # Notification lookup by object
    add_index :notifications, [:notifiable_id, :notifiable_type]

    remove_column :user_messages, :messageable_id, :integer
    remove_column :user_messages, :messageable_type, :string
    remove_column :user_messages, :acknowledged, :boolean
    remove_column :user_messages, :reply_to_id, :integer
  end
end
