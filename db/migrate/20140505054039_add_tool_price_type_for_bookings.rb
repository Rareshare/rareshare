class AddToolPriceTypeForBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :tool_price_type, :string
  end
end
