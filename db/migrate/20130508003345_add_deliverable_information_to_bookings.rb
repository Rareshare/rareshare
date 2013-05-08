class AddDeliverableInformationToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :sample_deliverable, :text
    add_column :bookings, :sample_transit, :string
  end
end
