class AddToolCalibrationAndCondition < ActiveRecord::Migration
  def change
    add_column :tools, :calibrated, :boolean
    add_column :tools, :last_calibrated_at, :datetime
    add_column :tools, :condition, :string
    add_column :tools, :condition_notes, :text
  end
end
