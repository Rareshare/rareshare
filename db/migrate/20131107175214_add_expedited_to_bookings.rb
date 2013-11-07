class AddExpeditedToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :expedited, :boolean, default: false
  end
end
