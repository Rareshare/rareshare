class AddUnitsToTools < ActiveRecord::Migration
  def change
    # Choice of string column is to allow mapping to ruby-units definitions.
    add_column :tools, :sample_size_unit_id, :string
    add_column :tools, :resolution_unit_id, :string
    remove_column :tools, :resolution
    add_column :tools, :resolution, :integer

    create_table :available_units do |t|
      t.string :name
    end
  end
end
