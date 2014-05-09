class BookingEdit < ActiveRecord::Base
  include ActiveModel::Transitions
  belongs_to :booking

  validates_presence_of :change_amount
  validates_length_of :memo, maximum: 100

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
end