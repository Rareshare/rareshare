class AddLeadAndExpediteDaysToPerTimeToolPrices < ActiveRecord::Migration
  def change
    add_column :per_time_tool_prices, :lead_time_days, :integer
    add_column :per_time_tool_prices, :expedite_time_days, :integer
  end
end
