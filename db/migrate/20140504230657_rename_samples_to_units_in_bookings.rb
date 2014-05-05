class RenameSamplesToUnitsInBookings < ActiveRecord::Migration
  def change
    rename_column :bookings, :samples, :units
  end
end
