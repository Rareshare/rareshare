class Transaction < ActiveRecord::Base
  belongs_to :booking
  validates :amount, :booking_id, :customer_id, presence: true
  belongs_to :customer, class_name: "User"
end
