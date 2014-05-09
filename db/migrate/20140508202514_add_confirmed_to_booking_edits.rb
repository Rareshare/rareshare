class AddConfirmedToBookingEdits < ActiveRecord::Migration
  def change
    add_column :booking_edits, :confirmed, :boolean, default: false
  end
end
