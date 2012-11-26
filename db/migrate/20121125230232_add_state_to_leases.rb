class AddStateToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :state, :string
  end
end
