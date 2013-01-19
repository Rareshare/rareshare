class AddToolsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tools_count, :integer, default: 0
  end
end
