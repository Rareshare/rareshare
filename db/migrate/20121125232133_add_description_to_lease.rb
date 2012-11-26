class AddDescriptionToLease < ActiveRecord::Migration
  def change
    add_column :leases, :description, :text
  end
end
