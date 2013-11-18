class AddDepartmentToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :department, :string
  end
end
