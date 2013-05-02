class RemoveBadColumnsFromImages < ActiveRecord::Migration
  def up
    remove_column :images, "string"
    remove_column :images, "integer"
  end

  def down
  end
end
