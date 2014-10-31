class ChangeMoneyFieldsToDecimal < ActiveRecord::Migration
  def up
    fields.each_pair do |table, *columns|
      columns.flatten.each do |column|
        change_column table, column, :decimal, precision: 8, scale: 2
      end
    end    
  end

  def down
    fields.each_pair do |table, *columns|
      columns.flatten.each do |column|
        change_column table, column, :money
      end
    end
  end

  private
  def fields
    {
      booking_edits: :change_amount,
      bookings: [:price, :shipping_price, :rareshare_fee],
      per_sample_tool_prices: [:base_amount, :setup_amount],
      per_time_tool_prices: [:setup_amount, :amount_per_time_unit],
      transactions: :amount
    }
  end

end
