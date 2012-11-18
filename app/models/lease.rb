class Lease < ActiveRecord::Base
  belongs_to :lessor, class_name: "User"
  belongs_to :lessee, class_name: "User"
  belongs_to :unit

  validates_presence_of :lessor, :lessee, :unit

  def cancelled?
    !cancelled_at.nil?
  end

  def duration
    ended_at - started_at
  end
end
