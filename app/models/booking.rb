class Booking < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :renter, class_name: "User"
  belongs_to :tool
  has_one :owner, through: :tool
  has_many :booking_logs

  has_many :user_messages, as: :messageable

  def message_chain
    user_messages.first.try(:message_chain) || []
  end

  def append_message(attrs)
    ( user_messages.first || UserMessage.new ).append attrs
  end

  validates_presence_of :tool_id, :renter_id, :tool_id, :sample_description, :deadline, :price, :sample_deliverable, :sample_transit
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."
  validate :renter_cannot_be_owner

  scope :active, where(state: [:pending, :confirmed, :overdue])

  after_create :notify_booking_requested, if: :pending?
  after_create :log_booking_requested, if: :pending?

  state_machine do
    state :pending
    state :confirmed
    state :denied
    state :cancelled
    state :completed
    state :overdue

    event :confirm, success: :notify_booking_confirmed do
      transitions from: :pending, to: :confirmed
    end

    event :cancel, success: :notify_booking_cancelled do
      transitions from: [:pending, :confirmed], to: :cancelled
    end

    event :deny, success: :notify_booking_cancelled do
      transitions from: [:pending], to: :denied
    end

    event :complete do
      transitions from: [:confirmed, :overdue], to: :completed
    end

    event :warn do
      transitions from: :confirmed, to: :overdue
    end
  end

  def transition!(state, updated_by)
    old_state = self.state

    if respond_to?(state)
      self.send "#{state}!"
      self.booking_logs.create updated_by_id: updated_by.id, old_state: old_state, new_state: self.state
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

  def party?(user)
    renter?(user) || owner?(user)
  end

  def owner?(user)
    user == self.owner
  end

  def renter?(user)
    user == self.renter
  end

  def cancellable_by?(user)
    renter?(user) || ( owner?(user) && confirmed? )
  end

  def opposite_party_to(user)
    renter?(user) ? self.owner : self.renter
  end

  def state_summary_for(user)
    if owner?(user)
      if pending?
        "This person is currently waiting for a response from you."
      elsif confirmed?
        "You have approved this booking."
      elsif denied?
        "You have declined this booking."
      elsif cancelled?
        "This booking has been cancelled."
      end
    elsif renter?(user)
      if pending?
        "You are waiting for a response from the owner of this tool."
      elsif confirmed?
        "The owner of the tool has agreed to this booking."
      elsif denied?
        "The owner of the tool has declined this booking."
      elsif cancelled?
        "This booking has been cancelled."
      end
    end
  end

  protected

  def set_cancelled_timestamp
    self.cancelled_at = Time.now
  end

  def log_booking_requested
    self.booking_logs.create updated_by_id: self.renter_id, new_state: self.state
  end

  def notify_booking_requested
    message_body = I18n.t("bookings.notify_requested",
      tool_name: tool.display_name,
      renter_name: self.renter.display_name,
      description: self.sample_description
    )

    append_message(
      receiver: self.owner,
      sender: self.renter,
      body: message_body
    )
  end

  def notify_booking_confirmed
    message_body = I18n.t("bookings.notify_confirmed",
      owner_name: self.owner.display_name
    )

    append_message(
      receiver: self.renter,
      sender: self.owner,
      body: message_body
    )
  end

  def notify_booking_cancelled
    message_body = I18n.t("bookings.notify_cancelled")

    append_message(
      receiver: self.owner,
      sender: self.renter,
      body: message_body
    )
  end

  def notify_booking_denied
    message_body = I18n.t("bookings.notify_denied",
      owner_name: self.owner.display_name
    )

    append_message(
      receiver: self.renter,
      sender: self.owner,
      body: message_body
    )
  end

  def renter_cannot_be_owner
    if self.renter_id == self.tool.owner_id
      errors.add "renter_id", "You can't book your own tool!"
    end
  end

end
