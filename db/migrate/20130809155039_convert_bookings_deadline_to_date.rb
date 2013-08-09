class ConvertBookingsDeadlineToDate < ActiveRecord::Migration
  def change
    change_column :bookings, :deadline, :date
  end
end
