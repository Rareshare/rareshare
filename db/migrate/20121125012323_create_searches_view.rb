class CreateSearchesView < ActiveRecord::Migration
  def up
    create_table :searches, id: false do |t|
      t.text    "document"
      t.integer "searchable_id"
      t.string  "searchable_type"
    end

    execute <<-SQL
      CREATE INDEX ON searches USING gin(to_tsvector('english', document));
      CREATE INDEX ON searches USING gin(to_tsvector('english', searchable_type));
    SQL
  end

  def down
    drop_table :searches
  end
end
