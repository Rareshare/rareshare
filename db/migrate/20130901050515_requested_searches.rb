class RequestedSearches < ActiveRecord::Migration
  def change
    create_table :requested_searches do |t|
      t.text :request
      t.integer :user_id
    end
  end
end
