class FixBookingCurrencies < ActiveRecord::Migration
  def up
    update <<-SQL
      UPDATE bookings
      SET currency = tools.currency
      FROM tools
      WHERE bookings.tool_id = tools.id
    SQL
  end
end
