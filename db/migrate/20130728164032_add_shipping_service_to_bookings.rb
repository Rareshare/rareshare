class AddShippingServiceToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :shipping_service, :string
  end
end
