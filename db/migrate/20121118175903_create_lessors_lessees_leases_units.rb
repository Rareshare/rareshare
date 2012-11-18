class CreateLessorsLesseesLeasesUnits < ActiveRecord::Migration
  def change
    create_table :leases do |t|
      t.integer :lessor_id
      t.integer :lessee_id
      t.integer :tool_id
      t.datetime :started_at
      t.datetime :ended_at
      t.datetime :cancelled_at
      t.timestamps
    end

    create_table :tools do |t|
      t.integer :owner_id
      t.integer :model_id
      t.string :resolution
      t.string :sample_size
      t.boolean :technician_required
      t.integer :price_per_hour
      t.timestamps
    end
  end
end
