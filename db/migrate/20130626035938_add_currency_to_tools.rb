class AddCurrencyToTools < ActiveRecord::Migration
  def change
    add_column :tools, :currency, :string, limit: 3
    add_column :bookings, :currency, :string, limit: 3
    Tool.update_all currency: "USD"
    Booking.update_all currency: "USD"
  end
end
