class AddTypeAndFileColumnsToStoredFiles < ActiveRecord::Migration
  def change
    add_column :files, :file, :string
    add_column :files, :type, :string
    add_index :files, :type

    execute "DELETE FROM files"
    execute "DELETE FROM file_attachments"
  end
end
