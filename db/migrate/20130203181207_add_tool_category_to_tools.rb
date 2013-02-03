class AddToolCategoryToTools < ActiveRecord::Migration
  def change
    add_column :tools, :tool_category_id, :integer
  end
end
