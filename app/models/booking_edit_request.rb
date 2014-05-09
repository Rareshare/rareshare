class BookingEditRequest < ActiveRecord::Base
  include ActiveModel::Transitions
  belongs_to :booking

  validates_length_of :memo, maximum: 100

  state_machine do
    state :pending
    state :accepted
    state :declined

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :decline do
      transitions from: :pending, to: :declined
    end
  end

  state_machine.states.each do |state|
    scope state.name, lambda { where(state: state.name) }
  end
end