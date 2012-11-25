class Lease < ActiveRecord::Base
  belongs_to :lessor, class_name: "User"
  belongs_to :lessee, class_name: "User"
  belongs_to :tool

  validates_presence_of :lessor_id, :lessee_id, :tool_id

  def cancelled?
    !cancelled_at.nil?
  end

  def duration
    ended_at - started_at
  end
end
