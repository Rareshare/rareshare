class AddTrackedSearches < ActiveRecord::Migration
  def change
    execute "CREATE EXTENSION IF NOT EXISTS hstore;"

    create_table :executed_searches do |t|
      t.column :user_id,       :integer, required: true
      t.column :search_params, :hstore
      t.column :results_count, :integer, required: true
      t.timestamps
    end
  end
end
