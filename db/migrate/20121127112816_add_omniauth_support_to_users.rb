class AddOmniauthSupportToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :image_url, :string
    add_column :users, :linkedin_profile_url, :string
  end
end
