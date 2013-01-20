class AddYearAndSerialToTools < ActiveRecord::Migration
  def change
    add_column :tools, :year_manufactured, :integer
    add_column :tools, :serial_number, :string
  end
end
