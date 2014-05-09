class BookingEdit < ActiveRecord::Base
  belongs_to :booking

  validates_presence_of :change_amount
  validates_length_of :memo, maximum: 100

  scope :unconfirmed, -> { where(confirmed: false) }
end