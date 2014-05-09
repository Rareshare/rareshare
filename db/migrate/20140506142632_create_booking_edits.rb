class CreateBookingEdits < ActiveRecord::Migration
  def change
    create_table :booking_edits do |t|
      t.integer :booking_id
      t.column :change_amount, :money
      t.string :memo
      t.timestamps
    end
  end
end
