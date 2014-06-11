# encoding: UTF-8
class Booking < ActiveRecord::Base
  include ActiveModel::Transitions
  include ActiveModel::ForbiddenAttributesProtection
  include ActionView::Helpers::NumberHelper

  RARESHARE_FEE_PERCENT = BigDecimal.new("0.10")

  # load translation at compile time
  I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]

  belongs_to :renter, class_name: "User"
  belongs_to :last_updated_by, class_name: "User"
  belongs_to :tool
  belongs_to :tool_price, polymorphic: true
  belongs_to :address

  has_one    :owner, through: :tool
  has_many   :booking_logs
  has_many   :notifications, as: :notifiable
  has_many   :questions, as: :questionable
  has_many   :question_notifications, through: :questions
  has_many   :question_responses, through: :questions
  has_many   :answer_notifications, through: :question_responses
  has_many   :booking_edits, dependent: :destroy
  has_many   :booking_edit_requests, dependent: :destroy

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :ignores_address?

  attr_accessor :updated_by   # Virtual attribute to enforce last_updated_by update.
  attr_accessor :stripe_token # Virtual attribute to assist with Stripe payment.

  validates :tool_id,
            :renter_id,
            :tool_id,
            :sample_description,
            :deadline,
            :price,
            :sample_deliverable,
            :sample_transit,
            :sample_disposal,
            :updated_by,
            :units,
            presence: true

  validates :units,
            numericality: { greater_than: 0, allow_nil: false }

  validates_inclusion_of :tos_accepted, in: [ "1", 1, true ], message: "Please accept the Terms of Service."
  validate :renter_cannot_be_owner

  before_save :persist_updated_by
  after_save :create_booking_log
  after_save :notify_booking_state

  scope :non_draft, lambda { where.not(state: :draft) }
  scope :rented,    lambda { where(state: [:finalized, :processing, :completed, :overdue]) }
  scope :active,    lambda { where(state: [:pending, :confirmed, :finalized, :overdue]) }
  scope :recent,    lambda { where("#{table_name}.updated_at > ?", 1.month.ago)}

  scope :can, lambda {|state|
    # TODO Fix the library and replace once patch accepted.
    from_states = state_machine.events[state.to_sym].instance_variable_get("@transitions").map &:from
    where(state: from_states)
  }

  class << self
    def default(renter, tool, params={})
      deadline = if params[:date].present?
        Date.parse(params[:date])
      else
        tool.earliest_bookable_date
      end

      self.new do |b|
        b.renter_id  = renter.id
        b.tool_id    = tool.id
        b.deadline   = deadline
        b.tool_price_id = tool.tool_price_for(params[:subtype]).try(:id)
        b.tool_price_type = tool.tool_price_for().class.name
        b.currency   = tool.currency
        b.expedited  = false
        b.units    = 1
        b.use_user_address = renter.address.present?
        b.build_address
      end
    end
  end

  module Transit
    IN_PERSON      = :in_person
    RARESHARE_SEND = :rareshare_send
    RENTER_SEND    = :renter_send
    DIGITAL_SEND   = :digital_send
    NONE_REQUIRED  = :none_required

    ALL        = [ IN_PERSON, RENTER_SEND, DIGITAL_SEND, NONE_REQUIRED ]
    COLLECTION = ALL.map {|k| [ I18n.t("bookings.sample_transit.#{k}"), k ]}
  end

  module Disposal
    IN_PERSON      = :in_person
    RARESHARE_SEND = :rareshare_send
    OWNER_DISPOSE  = :owner_dispose
    NONE_REQUIRED  = :none_required

    ALL        = [ IN_PERSON, OWNER_DISPOSE, NONE_REQUIRED ]
    COLLECTION = ALL.map {|k| [ I18n.t("bookings.sample_disposal.#{k}"), k ]}
  end

  module PackageSize
    ENVELOPE   = "UPSLetter"
    PAK        = "Pak"
    BOX_SMALL  = "SmallExpressBox"
    BOX_MEDIUM = "MediumExpressBox"
    BOX_LARGE  = "LargeExpressBox"

    ALL        = [ ENVELOPE, PAK, BOX_SMALL, BOX_MEDIUM, BOX_LARGE ]
    COLLECTION = ALL.map {|k| [ I18n.t("shipping.package_size.#{k}"), k]}
  end

  state_machine do
    state :draft
    state :pending
    state :edited_by_owner
    state :edit_requested
    state :edited_by_renter
    state :confirmed
    state :denied
    state :cancelled
    state :completed
    state :overdue
    state :finalized
    state :processing
    state :expired

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :owner_edit do
      transitions from: :pending, to: :edited_by_owner
    end

    event :cancel_owner_edit do
      transitions from: :edited_by_owner, to: :pending
    end

    event :cancel_edit_request do
      transitions from: :edit_requested, to: :pending
    end

    event :request_edit do
      transitions from: :pending, to: :edit_requested
    end

    event :renter_respond_to_edit_request do
      transitions from: :edit_requested, to: :pending
    end

    event :renter_respond_to_edit do
      transitions from: :edited_by_owner, to: :pending
    end

    event :cancel do
      transitions from: [:pending, :confirmed, :finalized], to: :cancelled
    end

    event :deny do
      transitions from: [:pending], to: :denied
    end

    event :complete do
      transitions from: [:processing, :overdue], to: :completed
    end

    event :warn do
      transitions from: :processing, to: :overdue
    end

    event :finalize do
      transitions from: :confirmed, to: :finalized
    end

    event :expire do
      transitions from: [:pending, :confirmed], to: :expired
    end

    event :begin do
      transitions from: :finalized, to: :processing
    end
  end

  state_machine.states.each do |state|
    scope state.name, lambda { where(state: state.name) }
  end

  def save_draft(renter)
    self.renter     = renter
    self.updated_by = renter
    self.price      = tool_price.revised_price_for(units, expedited: expedited)
    self.currency   = tool.currency
    self.deadline   = expedited ? tool_price.earliest_expedite_date : tool_price.earliest_bookable_date
    save(validate: false)
  end

  def reserve(renter)
    self.state      = "pending"
    self.renter     = renter
    self.updated_by = renter
    self.price      = tool_price.revised_price_for(units, expedited: expedited)
    self.currency   = tool.currency
    self.deadline   = expedited ? tool_price.earliest_expedite_date : tool_price.earliest_bookable_date

    if ignores_address?
      self.address = nil
    elsif b.use_user_address?
      self.address = renter.address
    end

    self.rareshare_fee = price * RARESHARE_FEE_PERCENT

    save
  end

  def title
    self.state.titleize + " " + self.class.model_name.name.titleize
  end

  def display_name
    tool.display_name + " - " + deadline.to_date.to_s(:long)
  end

  def public_address
    if pending?
      tool.partial_address
    else
      tool.full_street_address
    end
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

  def ship_outgoing?
    self.sample_transit.to_s == Booking::Transit::RARESHARE_SEND.to_s
  end

  def ship_return?
    self.sample_disposal.to_s == Booking::Disposal::RARESHARE_SEND.to_s
  end

  def outgoing_shipment
    @outgoing_shipment ||= begin
      if ship_outgoing?
        from   = self.address.easypost_address(name: renter.display_name)
        to     = tool.address.easypost_address(name: owner.display_name)
        parcel = EasyPost::Parcel.create(predefined_package: self.shipping_package_size, weight: 16.0)

        EasyPost::Shipment.create(to_address: to, from_address: from, parcel: parcel)
      else
        nil
      end
    end
  end

  def currency_symbol
    ( self.currency.blank? || self.currency == "USD" ) ? "$" : "£"
  end

  def outgoing_shipment_rates
    ( outgoing_shipment.try(:rates) || [] ).map do |rate|
      service = I18n.t("shipping.rates.#{rate.service}")
      displayed_rate = number_to_currency rate.rate, unit: self.currency_symbol

      {
        display_name: "#{service} (#{displayed_rate})",
        rate: rate.rate,
        service: rate.service
      }
    end
  end

  def return_shipment
    @return_shipment ||= begin
      if ship_return?
        to     = self.address.easypost_address(name: renter.display_name)
        from   = tool.address.easypost_address(name: owner.display_name)
        parcel = EasyPost::Parcel.create(predefined_package: self.shipping_package_size, weight: 16.0)

        EasyPost::Shipment.create(to_address: to, from_address: from, parcel: parcel)
      else
        nil
      end
    end
  end

  def ignores_address?
    !( ship_outgoing? || ship_return? )
  end

  def use_user_address=(val)
    val = ( val == "1" ) if val.is_a? String
    @use_user_address = val
  end

  def use_user_address
    defined?(@use_user_address) ? @use_user_address : true
  end

  alias_method :use_user_address?, :use_user_address

  def as_json(options={})
    unless options[:minimal]
      options = options.merge(
        methods: [
          :use_user_address,
          :outgoing_shipment_rates,
          :currency_symbol,
          :tool,
          :tool_price,
          :edits_price,
          :payment_fee
        ]
      )
    end

    super options
  end

  def final_price
    price + edits_price + shipping_price + rareshare_fee
  end

  def final_price_in_cents
    ( final_price * 100 ).to_i
  end

  def edits_price
    booking_edits.confirmed.sum :change_amount
  end

  def price_with_all_fees
    final_price + payment_fee
  end

  def payment_fee
    if currency_symbol == '$'
      # based on Stripe's fee of 2.9% + $0.30
      (final_price * 0.029) + 0.3
    else
      # based on Stripe's fee of 2.4% + £0.20
      (final_price * 0.024) + 0.2
    end
  end

  def price_per_unit
    if tool.price_type == 'sample'
      expedited? ? tool_price.expedite_amount : tool_price.base_amount
    else
      expedited? ? tool_price.expedite_amount : tool_price.amount_per_time_unit
    end
  end

  def apply_adjustment(adjustment)
    update_columns(
      units: units + adjustment,
      price: price + adjustment * price_per_unit
    )
  end

  def pay!
    if owner.stripe_access_token
      Stripe::Charge.create(
        { amount: self.final_price_in_cents,
        currency: self.currency,
        card: self.stripe_token,
        description: self.display_name + " by " + self.renter.display_name,
        application_fee: (self.rareshare_fee * 100).to_i },
        owner.stripe_access_token
      )

      self.class.transaction do
        self.updated_by = renter
        self.finalize!
        Transaction.create! booking: self, customer: self.renter, amount: self.final_price
      end
    else
      errors.add :base, "The owner has not connected to Stripe yet."
    end
  rescue Stripe::CardError => e
    errors.add :stripe_token, I18n.t("payment.declined")
    false
  rescue => e
    errors.add :base, I18n.t("payment.error", message: e.message)
    # TODO Capture this in a proper error handling service.
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    false
  end

  def ask_question(params={})
    self.questions.create(params).tap do |question|
      if question.valid?
        self.notifications.create(
          user: self.opposite_party_to(question.user),
          properties: {
            key: "bookings.notify.asked",
            tool_name: self.tool.display_name,
            question: question.body.truncate(100)
          }
        )
      end
    end
  end

  def pending_answer_notifications
    notifications.answers.unseen
  end

  def pending_question_notifications
    notifications.questions.unseen
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

  def create_booking_log
    booking_logs.create(state: state, updated_by: last_updated_by)
  end

  def notify_booking_state
    if state == "finalized"
      # sending to both parties
      ["owner", "renter"].each do |receiver|
        notifications.create(
          user: send(receiver.to_sym),
          properties: {
            key: "bookings.notify.finalized_#{receiver}",
            state: state,
            tool_name: tool.display_name,
            tool_id: tool.id,
            booking_id: id
          }
        )
      end
    elsif state != "draft"
      receiver = opposite_party_to(last_updated_by)

      n = notifications.create(
        user: receiver,
        properties: {
          key: "bookings.notify.#{state}", # This should maybe be a column.
          state: state,
          tool_name: tool.display_name,
          tool_id: tool.id,
          booking_id: id
        }
      )
    end
  end
end
