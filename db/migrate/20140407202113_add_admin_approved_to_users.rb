class AddAdminApprovedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_approved, :boolean, default: false
  end
end
