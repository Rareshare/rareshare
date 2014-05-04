class RenameToolPricesToPerSampleToolPrices < ActiveRecord::Migration
  def change
    rename_table :tool_prices, :per_sample_tool_prices
  end
end
