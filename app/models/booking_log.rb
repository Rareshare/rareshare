class BookingLog < ActiveRecord::Base
  belongs_to :booking
  belongs_to :updated_by, class_name: "User"
  validates :booking_id, :updated_by_id, :new_state, presence: true

  def state_transition_description
    if old_state.blank?
      "requested the booking"
    else
      "#{new_state} the #{old_state} booking"
    end
  end
end
