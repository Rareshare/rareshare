class BookingLog < ActiveRecord::Base
  belongs_to :booking
  belongs_to :updated_by, class_name: "User"
  validates :booking_id, :updated_by_id, :state, presence: true

  def log
    self.class.where(booking_id: self.booking_id).where("created_at < ?", self.created_at).order("created_at DESC")
  end

  def old_state
    @old_state ||= log.limit(1).first.try(:state)
  end

  def state_transition_description
    if state == "pending"
      "requested the booking"
    elsif state == "draft"
      "saved draft for the booking"
    else
      "#{state} the #{old_state} booking"
    end
  end
end
