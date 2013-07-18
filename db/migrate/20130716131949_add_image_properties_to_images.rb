class AddImagePropertiesToImages < ActiveRecord::Migration
  def up
    drop_table :images

    create_table :files do |t|
      t.string :name
      t.integer :size
      t.string :content_type
      t.string :url
      t.integer :user_id
      t.timestamps
    end

    create_table :file_attachments do |t|
      t.integer :position,        null: false
      t.integer :attachable_id,   null: false
      t.string  :attachable_type, null: false
      t.integer :file_id,         null: false
      t.string  :category
    end

    add_index :file_attachments, [:attachable_type, :attachable_id]
    add_index :file_attachments, [:file_id, :attachable_id, :attachable_type, :category], unique: true, name: 'index_file_attachments_for_uniqueness'
    add_index :files, :url, unique: true
  end

  def down
    create_table :images do |t|
      t.string :image
      t.string :imageable_id, :integer
      t.string :imageable_type, :string
    end

    drop_table :files
    drop_table :file_attachments
  end
end
