class UpdateUsersTosAccepted < ActiveRecord::Migration
  def up
    change_column :users, :tos_accepted, :boolean, default: false, nil: false
    User.update_all tos_accepted: false
  end

  def down
  end
end
