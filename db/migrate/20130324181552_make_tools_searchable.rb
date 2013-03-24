class MakeToolsSearchable < ActiveRecord::Migration
  def up
    add_column :tools, :document, :text

    execute <<-SQL
      CREATE INDEX ON tools USING gin(to_tsvector('english', document));
    SQL

    Tool.all.each &:save
  end

  def down
    remove_column :tools, :document
  end
end
