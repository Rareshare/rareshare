class AddHasResolutionFlagToTools < ActiveRecord::Migration
  def change
    add_column :tools, :has_resolution, :boolean
    Tool.update_all has_resolution: true
  end
end
