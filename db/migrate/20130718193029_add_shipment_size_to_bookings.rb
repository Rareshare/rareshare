class AddShipmentSizeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :shipping_package_size, :string
    add_column :bookings, :shipping_weight, :decimal
    add_column :bookings, :shipping_price, :money
    add_column :bookings, :rareshare_fee, :money
  end
end
