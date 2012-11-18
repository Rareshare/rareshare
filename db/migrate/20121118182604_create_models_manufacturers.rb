class CreateModelsManufacturers < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :name
      t.integer :manufacturer_id
      t.timestamps
    end

    create_table :manufacturers do |t|
      t.string :name
      t.timestamps
    end
  end
end
