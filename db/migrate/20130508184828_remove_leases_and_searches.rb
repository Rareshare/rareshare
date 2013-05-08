class RemoveLeasesAndSearches < ActiveRecord::Migration
  def change
    drop_table :leases
    drop_table :searches
  end
end
