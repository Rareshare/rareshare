class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.float :latitude
      t.float :longitude
      t.string  :addressable_type
      t.integer :addressable_id
      t.timestamps
    end
  end
end
