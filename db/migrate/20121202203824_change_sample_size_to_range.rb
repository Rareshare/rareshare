class ChangeSampleSizeToRange < ActiveRecord::Migration
  def change
    add_column :tools, :sample_size_min, :integer
    add_column :tools, :sample_size_max, :integer
    remove_column :tools, :sample_size
  end
end
