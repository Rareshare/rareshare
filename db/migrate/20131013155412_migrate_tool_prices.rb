class MigrateToolPrices < ActiveRecord::Migration
  def up
    Tool.all.each do |t|
      t.tool_prices.create!(
        subtype: PerSampleToolPrice::Subtype::BENCH_STANDARD,
        base_amount: t.base_price,
        lead_time_days: t.base_lead_time,
        expedite_time_days: t.expedited_lead_time
      )
    end
  end

  def down
    # Nothing to do.
  end
end
