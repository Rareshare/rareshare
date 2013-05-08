class CreateBookingsUpdatedByField < ActiveRecord::Migration
  def change
    add_column :bookings, :last_updated_by_id, :integer
    remove_column :bookings, :cancelled_at
  end
end
