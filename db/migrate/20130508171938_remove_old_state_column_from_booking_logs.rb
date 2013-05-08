class RemoveOldStateColumnFromBookingLogs < ActiveRecord::Migration
  def change
    rename_column :booking_logs, :new_state, :state
    remove_column :booking_logs, :old_state
  end
end
