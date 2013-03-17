class ReconfigureToolLeasing < ActiveRecord::Migration
  def change
    remove_column :tools, :price_per_hour
    remove_column :tools, :technician_required
    add_column :tools, :base_lead_time, :integer
    add_column :tools, :base_price, :money
    add_column :tools, :can_expedite, :boolean
    add_column :tools, :expedited_lead_time, :integer
    add_column :tools, :expedited_price, :money

    create_table :bookings do |t|
      t.integer :renter_id
      t.integer :tool_id
      t.integer :price
      t.datetime :deadline
      t.text :sample_description
      t.string :state
      t.datetime :cancelled_at
      t.boolean :tos_accepted
      t.timestamps
    end

    add_index :bookings, :state
  end
end
