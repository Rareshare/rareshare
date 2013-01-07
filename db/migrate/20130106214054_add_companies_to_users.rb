class AddCompaniesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :users, :organization, :string
    add_column :users, :education, :string
    add_column :users, :bio, :text
    add_column :users, :primary_phone, :string
    add_column :users, :secondary_phone, :string
    add_column :users, :qualifications, :text
  end
end
