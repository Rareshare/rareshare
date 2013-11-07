class AddPriceSubtypeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :tool_price_id, :integer
  end
end
