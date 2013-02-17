class Lease < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :lessor, class_name: "User"
  belongs_to :lessee, class_name: "User"
  belongs_to :tool

  has_many :user_messages, as: :messageable

  validates_presence_of :lessor_id, :lessee_id, :tool_id, :description
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."
  validate :lessee_cannot_be_lessor

  scope :active, where(state: [:pending, :confirmed])

  after_create :notify_lessor_requested, if: :pending?

  state_machine do
    state :pending
    state :confirmed
    state :denied
    state :cancelled
    state :completed

    event :confirm, success: :notify_lessee_confirmed do
      transitions from: :pending, to: :confirmed
    end

    event :cancel, success: :set_cancelled_timestamp do
      transitions from: [:pending, :confirmed], to: :denied
    end

    event :deny, success: :notify_lessee_denied do
      transitions from: [:pending, :confirmed], to: :denied
    end

    event :complete do
      transitions from: :confirmed, to: :completed
    end
  end

  def duration
    started_at..ended_at
  end

  def duration_in_days
    duration.to_a.length
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

  protected

  def set_cancelled_timestamp
    self.cancelled_at = Time.now
  end

  def notify_lessor_requested
    user_messages.build.tap do |m|
      m.receiver = self.lessor
      m.sender = self.lessee
      m.messageable = self
      m.body = "You've received a request to lease your tool #{tool.display_name} from #{self.lessee.display_name}. Here's what they'd like to do with it: <blockquote>#{self.description}</blockquote> Please reply back with any questions you have for them, or click Approve to approve the lease.".html_safe
    end.save!
  end

  def notify_lessee_confirmed
    # user_messages.build.tap do |m|
    #   m.receiver = self.lessee
    #   m.sender = self.lessor
    #   m.messageable = self
    #   m.body = "This is an automated message to let you know that your lease has been confirmed. Please reply back to this message with any questions and I'll get back to you as soon as I can."
    # end.save!
  end

  def lessee_cannot_be_lessor
    if self.lessee_id == self.lessor_id
      errors.add "lessee_id", "You cannot lease your own tool."
    end
  end

end
