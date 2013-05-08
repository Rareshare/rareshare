class Booking < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :renter, class_name: "User"
  belongs_to :last_updated_by, class_name: "User"
  belongs_to :tool
  has_one :owner, through: :tool
  has_many :booking_logs
  has_many :user_messages, as: :messageable

  attr_accessor :updated_by # Virtual attribute to enforce last_updated_by update.

  validates_presence_of :tool_id, :renter_id, :tool_id, :sample_description, :deadline, :price, :sample_deliverable, :sample_transit, :updated_by
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."
  validate :renter_cannot_be_owner

  before_save :persist_updated_by

  scope :active, where(state: [:pending, :confirmed, :overdue])

  state_machine do
    state :pending
    state :confirmed
    state :denied
    state :cancelled
    state :completed
    state :overdue

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :cancel do
      transitions from: [:pending, :confirmed], to: :cancelled
    end

    event :deny do
      transitions from: [:pending], to: :denied
    end

    event :complete do
      transitions from: [:confirmed, :overdue], to: :completed
    end

    event :warn do
      transitions from: :confirmed, to: :overdue
    end
  end

  def message_chain
    user_messages.first.try(:message_chain) || []
  end

  def append_message(attrs)
    if message_chain.empty?
      user_messages.create attrs
    else
      user_messages.first.append attrs
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

  def renter_cannot_be_owner
    if self.tool.present? && self.renter_id == self.tool.owner_id
      errors.add "renter_id", "You can't book your own tool!"
    end
  end

  def persist_updated_by
    self.last_updated_by_id = self.updated_by.id
  end

end
