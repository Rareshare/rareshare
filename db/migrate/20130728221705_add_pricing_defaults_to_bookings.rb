class AddPricingDefaultsToBookings < ActiveRecord::Migration
  ZERO = BigDecimal.new("0.00")

  def change
    change_column :bookings, :price,          :money, nil: false, default: ZERO
    change_column :bookings, :rareshare_fee,  :money, nil: false, default: ZERO
    change_column :bookings, :shipping_price, :money, nil: false, default: ZERO
  end
end
