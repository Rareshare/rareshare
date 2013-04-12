class Booking < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :renter, class_name: "User"
  belongs_to :tool
  has_one :owner, through: :tool

  has_many :user_messages, as: :messageable

  def message_chain
    user_messages.first.try(:message_chain) || []
  end

  validates_presence_of :tool_id, :renter_id, :tool_id, :sample_description, :deadline, :price
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."
  validate :renter_cannot_be_owner

  scope :active, where(state: [:pending, :confirmed, :overdue])

  after_create :notify_booking_requested, if: :pending?

  state_machine do
    state :pending
    state :confirmed
    state :denied
    state :cancelled
    state :completed
    state :overdue

    event :confirm, success: :notify_booking_approved do
      transitions from: :pending, to: :confirmed
    end

    event :cancel, success: :notify_booking_cancelled do
      transitions from: [:pending, :confirmed], to: :denied
    end

    event :deny, success: :notify_booking_cancelled do
      transitions from: [:pending, :confirmed], to: :denied
    end

    event :complete do
      transitions from: [:confirmed, :overdue], to: :completed
    end

    event :warn do
      transitions from: :confirmed, to: :overdue
    end
  end

  def duration
    started_at..ended_at
  end

  def display_name
    tool.display_name + " - " + deadline.to_date.to_s(:long)
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

  def reserved_by?(user)
    self.renter == user
  end

  def total_cost
    tool.price_for deadline.to_date
  end

  def expedited?
    tool.must_expedite? deadline.to_date
  end

  def can_be_shown_to?(user)
    tool.owner_id == user.id || renter_id == user.id
  end

  def public_address
    if pending?
      tool.partial_address
    else
      tool.full_street_address
    end
  end

  def address_for_map
    public_address.gsub(/,\s,/, ',').gsub(/\s/, '+')
  end

  protected

  def set_cancelled_timestamp
    self.cancelled_at = Time.now
  end

  def notify_booking_requested
    user_messages.build.tap do |m|
      m.receiver = self.owner
      m.sender = self.renter
      m.messageable = self
      m.body = "You've received a request to book your tool #{tool.display_name} from #{self.renter.display_name}. Here's what they'd like to do with it: <blockquote>#{self.sample_description}</blockquote> Please reply back with any questions you have for them, or click Approve to approve the booking.".html_safe
    end.save!
  end

  def notify_booking_approved
  end

  def notify_booking_cancelled
  end

  def notify_booking_cancelled
  end

  def renter_cannot_be_owner
    if self.renter_id == self.tool.owner_id
      errors.add "renter_id", "You can't book your own tool!"
    end
  end

end
