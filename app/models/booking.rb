class Booking < ActiveRecord::Base
  include ActiveModel::Transitions
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :renter, class_name: "User"
  belongs_to :last_updated_by, class_name: "User"
  belongs_to :tool
  belongs_to :address
  has_one :owner, through: :tool
  has_many :booking_logs
  has_many :user_messages, as: :messageable

  accepts_nested_attributes_for :address, allow_destroy: true

  attr_accessor :updated_by # Virtual attribute to enforce last_updated_by update.

  validates_presence_of :tool_id, :renter_id, :tool_id, :sample_description, :deadline, :price, :sample_deliverable, :sample_transit, :updated_by
  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."
  validate :renter_cannot_be_owner

  before_save :persist_updated_by

  scope :active, where(state: [:pending, :confirmed, :finalized, :overdue])
  scope :recent, lambda { where("#{table_name}.updated_at > ?", 1.month.ago)}

  scope :can, lambda {|state|
    # TODO Fix the library and replace once patch accepted.
    from_states = state_machine.events[state.to_sym].instance_variable_get("@transitions").map &:from
    where(state: from_states)
  }

  module Transit
    IN_PERSON      = :in_person
    RARESHARE_SEND = :rareshare_send
    RENTER_SEND    = :renter_send
    DIGITAL_SEND   = :digital_send
    NONE_REQUIRED  = :none_required

    ALL = [ IN_PERSON, RARESHARE_SEND, RENTER_SEND, DIGITAL_SEND, NONE_REQUIRED ]
  end

  state_machine auto_scopes: true do
    state :pending
    state :confirmed
    state :denied
    state :cancelled
    state :completed
    state :overdue
    state :finalized
    state :expired

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :cancel do
      transitions from: [:pending, :confirmed, :finalized], to: :cancelled
    end

    event :deny do
      transitions from: [:pending], to: :denied
    end

    event :complete do
      transitions from: [:finalized, :overdue], to: :completed
    end

    event :warn do
      transitions from: :confirmed, to: :overdue
    end

    event :finalize do
      transitions from: :confirmed, to: :finalized
    end

    event :expire do
      transitions from: [:pending, :confirmed], to: :expired
    end
  end

  def message_chain
    chain = user_messages.first.try(:message_chain) || []

    if chain.present?
      chain.order("created_at ASC")
    else
      []
    end
  end

  def append_message(attrs)
    if message_chain.empty?
      user_messages.create attrs
    else
      user_messages.first.append attrs
    end
  end

  def title
    self.state.titleize + " " + self.class.model_name.titleize
  end

  def display_name
    tool.display_name + " - " + deadline.to_date.to_s(:long)
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
    public_address.gsub(/,\s,/, ',').gsub(/\s/, '+').gsub(/#/, '%23')
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
    renter?(user) || ( owner?(user) && ( confirmed? || finalized? ) )
  end

  def opposite_party_to(user)
    renter?(user) ? self.owner : self.renter
  end

  def state_summary_for(user)
    viewer = owner?(user) ? "owner" : "renter"
    I18n.t("bookings.state.#{viewer}.#{state}")
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
