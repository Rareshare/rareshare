class AddMoreAccessInformation < ActiveRecord::Migration
  def change
    Tool.update_all access_type: Tool::AccessType::DEFAULT
    add_column :tools, :access_type_notes, :text
  end
end
