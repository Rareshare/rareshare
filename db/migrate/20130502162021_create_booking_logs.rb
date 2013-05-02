class CreateBookingLogs < ActiveRecord::Migration
  def change
    create_table :booking_logs do |t|
      t.string :old_state
      t.string :new_state
      t.integer :booking_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
