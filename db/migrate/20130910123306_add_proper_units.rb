class AddProperUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.string :label
      t.timestamps
    end

    drop_table :available_units

    remove_column :tools, :sample_size_unit_id, :string
    remove_column :tools, :resolution_unit_id,  :string
    add_column    :tools, :sample_size_unit_id, :integer
    add_column    :tools, :resolution_unit_id,  :integer
  end
end
