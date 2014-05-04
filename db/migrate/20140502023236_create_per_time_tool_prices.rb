class CreatePerTimeToolPrices < ActiveRecord::Migration
  def change
    create_table :per_time_tool_prices do |t|
      t.integer :tool_id
      t.string :subtype
      t.string :time_unit
      t.column :setup_amount, :money, default: 0.0
      t.column :amount_per_time_unit, :money, default: 0.0
      t.timestamps
    end

    add_index :per_time_tool_prices, :tool_id
  end
end
