class Lease < ActiveRecord::Base
  belongs_to :lessor, class_name: "User"
  belongs_to :lessee, class_name: "User"
  belongs_to :tool

  validates_presence_of :lessor_id, :lessee_id, :tool_id
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."

  scope :active, where(cancelled_at: nil)

  def cancelled?
    !cancelled_at.nil?
  end

  def duration_in_days
    (( ( ended_at - started_at ) + 1.day ) / 1.day.to_i).to_i
  end

  def duration_text
    if duration_in_days == 1
      started_at.to_date.to_s(:long)
    else
      started_at.to_date.to_s(:mdy) + " - " + ended_at.to_date.to_s(:mdy)
    end
  end

  def total_cost
    ( duration_in_days * 8 * tool.price_per_hour ) / 100.0
  end

  def reserved_by?(user)
    self.lessee == user
  end

  def cancel!
    self.cancelled_at = Time.now
    self.save!
  end
end
