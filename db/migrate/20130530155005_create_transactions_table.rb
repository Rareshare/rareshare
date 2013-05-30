class CreateTransactionsTable < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :booking_id, null: false
      t.column  :amount, :money, null: false
      t.integer :customer_id, null: false
      t.timestamps
    end
  end
end
