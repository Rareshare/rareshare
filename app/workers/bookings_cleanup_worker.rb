class BookingsCleanupWorker
  include Sidekiq::Worker

  def perform
    admin_user = User.administrative

    Booking.can(:expire).where(deadline: 1.day.ago.to_date).each do |booking|
      booking.updated_by = admin_user
      booking.expire!
    end

    Booking.can(:warn).where(deadline: 1.day.ago.to_date).each do |booking|
      booking.updated_by = admin_user
      booking.warn!
    end
  end
end
