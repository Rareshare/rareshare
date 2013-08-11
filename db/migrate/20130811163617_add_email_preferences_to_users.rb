class AddEmailPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_email_news,   :boolean, default: true
    add_column :users, :can_email_status, :boolean, default: true
  end
end
