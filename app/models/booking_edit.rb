class BookingEdit < ActiveRecord::Base
  include ActiveModel::Transitions
  belongs_to :booking

  validates_presence_of :change_amount
  validates_length_of :memo, maximum: 100
  validate :change_amount_within_base_price

  state_machine do
    state :pending
    state :confirmed
    state :declined

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :decline do
      transitions from: :pending, to: :declined
    end
  end

  state_machine.states.each do |state|
    scope state.name, lambda { where(state: state.name) }
  end

  def change_amount_within_base_price
    other_edits = booking.booking_edits.where("state <> 'declined'")
    other_edits.where!("id <> ?", id) if persisted?
    previous_base = booking.price + other_edits.sum(:change_amount)
    if (previous_base + change_amount) < 0
      errors.add :change_amount, 'cannot be greater than the base price'
    end
  end

end
