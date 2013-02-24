class FixImageIdColumnType < ActiveRecord::Migration
  def up
    remove_index  :images, column: [:imageable_id, :imageable_type]
    remove_column :images, :imageable_id
    add_column    :images, :imageable_id, :integer
    add_index     :images, [:imageable_id, :imageable_type]
  end

  def down
  end
end
