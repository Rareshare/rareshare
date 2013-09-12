class AddToolAccessTypeToTools < ActiveRecord::Migration
  def change
    add_column :tools, :access_type, :string
  end
end
