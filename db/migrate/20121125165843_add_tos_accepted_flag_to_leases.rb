class AddTosAcceptedFlagToLeases < ActiveRecord::Migration
  def change
    add_column :leases, :tos_accepted, :boolean
  end
end
