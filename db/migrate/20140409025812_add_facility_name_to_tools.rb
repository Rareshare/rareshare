class AddFacilityNameToTools < ActiveRecord::Migration
  def change
    add_column :tools, :facility_name, :string
  end
end
