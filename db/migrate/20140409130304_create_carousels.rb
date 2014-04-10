class CreateCarousels < ActiveRecord::Migration
  def change
    create_table :carousels do |t|
      t.string :image
      t.string :resource_type
      t.integer :resource_id
      t.boolean :active, default: true
    end
  end
end
