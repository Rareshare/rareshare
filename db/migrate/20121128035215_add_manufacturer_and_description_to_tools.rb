class AddManufacturerAndDescriptionToTools < ActiveRecord::Migration
  def change
    add_column :tools, :description, :text
    add_column :tools, :manufacturer_id, :integer
  end
end
