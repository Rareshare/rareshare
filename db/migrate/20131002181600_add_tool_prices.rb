class AddToolPrices < ActiveRecord::Migration
  def change
    add_column :tools, :price_type, :string

    create_table :tool_prices do |t|
      t.integer :tool_id
      t.string  :subtype # ISO standard, daily/hourly
      t.column  :base_amount, :money, default: 0.0
      t.column  :setup_amount, :money, default: 0.0
      t.integer :lead_time_days
      t.integer :expedite_time_days
      t.timestamps
    end

    add_index :tool_prices, [:tool_id, :subtype]

    Tool.update_all price_type: Tool::PriceType::PER_SAMPLE
  end
end
