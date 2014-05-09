class CreateBookingEditRequests < ActiveRecord::Migration
  def change
    create_table :booking_edit_requests do |t|
      t.string :memo
      t.integer :booking_id
      t.integer :adjustment
      t.string :state
      t.timestamps
    end
  end
end
