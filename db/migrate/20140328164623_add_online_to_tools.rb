class AddOnlineToTools < ActiveRecord::Migration
  def change
    add_column :tools, :online, :boolean, default: true
  end
end
