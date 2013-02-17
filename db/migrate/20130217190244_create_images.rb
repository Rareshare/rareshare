class CreateImages < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string

    create_table :images do |t|
      t.string :image
      t.string :imageable_id, :integer
      t.string :imageable_type, :string
    end

    add_index :images, [:imageable_id, :imageable_type]
  end
end
