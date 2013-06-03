class AddSampleDisposalToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :sample_disposal, :string
    add_column :bookings, :disposal_instructions, :text
  end
end
