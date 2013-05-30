class ChangeColumnTypeOfBookingsPriceToMoney < ActiveRecord::Migration
  def change
    change_column :bookings, :price, :money
  end
end
