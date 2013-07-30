class AddRunCapacityAndAmountToToolsAndBookings < ActiveRecord::Migration
  def change
    add_column :tools, :samples_per_run, :integer, default: 1
    add_column :tools, :bulk_runs, :integer
    add_column :tools, :can_bulkify, :boolean, default: false
    add_column :bookings, :samples, :integer
  end
end
