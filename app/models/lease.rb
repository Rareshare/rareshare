class Lease < ActiveRecord::Base
  include AASM

  belongs_to :lessor, class_name: "User"
  belongs_to :lessee, class_name: "User"
  belongs_to :tool

  has_many :user_messages, as: :messageable

  validates_presence_of :lessor_id, :lessee_id, :tool_id, :description
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."

  scope :active, where(cancelled_at: nil)

  after_initialize :set_initial_state
  after_create :notify_lessor_requested, if: :pending?

  aasm column: :state do
    state :pending, initial: true, after_enter: :notify_lessor_requested
    state :confirmed
    state :denied
    state :cancelled
    state :completed

    event :confirm, after: :notify_lessee_confirmed do
      transitions from: :pending, to: :confirmed
    end

    event :cancel, after: :set_cancelled_timestamp do
      transitions from: [:pending, :confirmed], to: :cancelled
    end

    event :deny, after: :notify_lessee_denied do
      transitions from: [:pending, :confirmed], to: :denied
    end

    event :complete do
      transitions from: :confirmed, to: :completed
    end
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

  def description
    "#{self.tool.display_name} (#{self.duration_text})"
  end

  protected

  def set_cancelled_timestamp
    self.cancelled_at = Time.now
  end

  def notify_lessor_requested
    user_messages.create! receiver: self.lessor, sender: self.lessee, body: "Hi there! This is an automated message to let you know that I'd like to lease your tool for #{duration_text}. Please reply back to this message with any questions and I'll get back to you as soon as I can."
  end

  def notify_lessee_confirmed
    user_messages.create! receiver: self.lessee, sender: self.lessor, body: "Hi there! This is an automated message to let you know that your lease has been confirmed. Please reply back to this message with any questions and I'll get back to you as soon as I can."
  end

  def set_initial_state
    self.state = "pending"
  end

end
