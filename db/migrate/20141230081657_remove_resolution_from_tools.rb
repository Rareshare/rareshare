class RemoveResolutionFromTools < ActiveRecord::Migration
  def change
    remove_column :tools, :resolution, :integer
    remove_column :tools, :resolution_unit_id, :integer
    remove_column :tools, :has_resolution, :boolean, default: true
  end
end
