class ChangeConfirmedToStateForBookingEdits < ActiveRecord::Migration
  def change
    remove_column :booking_edits, :confirmed
    add_column :booking_edits, :state, :string
  end
end
