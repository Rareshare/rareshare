class Lease < ActiveRecord::Base
  belongs_to :lessor, class_name: "User"
  belongs_to :lessee, class_name: "User"
  belongs_to :tool

  validates_presence_of :lessor_id, :lessee_id, :tool_id
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."

  def cancelled?
    !cancelled_at.nil?
  end

  def duration_in_days
    (( ( ended_at - started_at ) + 1.day ) / 1.day.to_i).to_i
  end

  def total_cost
    ( duration_in_days * 8 * tool.price_per_hour ) / 100.0
  end
end
