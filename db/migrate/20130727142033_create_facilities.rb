class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.integer :user_id, nil: false
      t.string  :name
      t.timestamps
    end

    add_column :tools, :facility_id, :integer

    Tool.all.each do |t|
      f = t.build_facility user_id: t.owner_id
      f.save
      a = t.address
      a.addressable = f
      a.save
    end
  end
end
