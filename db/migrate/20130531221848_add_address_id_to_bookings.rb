class AddAddressIdToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :address_id, :integer
  end
end
