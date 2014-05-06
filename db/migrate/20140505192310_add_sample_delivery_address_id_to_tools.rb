class AddSampleDeliveryAddressIdToTools < ActiveRecord::Migration
  def change
    add_column :tools, :sample_delivery_address_id, :integer
  end
end
