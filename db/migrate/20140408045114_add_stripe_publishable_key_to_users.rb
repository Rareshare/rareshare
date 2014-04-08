class AddStripePublishableKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_publishable_key, :string
  end
end
