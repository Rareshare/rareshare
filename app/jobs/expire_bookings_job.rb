class ExpireBookingsJob

  def perform
    Booking.can(:expire).where("deadline < ?", Date.today).each do |b|
      b.updated_by = User.administrative
      b.expire!
    end
  end

end
