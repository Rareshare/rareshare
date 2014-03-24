class RemovePricingInformationFromToolsTable < ActiveRecord::Migration
  def up
    remove_column :tools, :base_lead_time, :integer
    remove_column :tools, :base_price, :money
    remove_column :tools, :can_expedite, :boolean
    remove_column :tools, :expedited_lead_time, :integer
    remove_column :tools, :expedited_price, :money
    remove_column :tools, :bulk_runs, :integer
    remove_column :tools, :can_bulkify, :boolean
  end
end
