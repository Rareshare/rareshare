class Tool < ActiveRecord::Base
  extend NameDelegator

  BULK_DISCOUNT = BigDecimal.new("0.80")

  has_many :bookings

  belongs_to :model
  belongs_to :manufacturer
  belongs_to :tool_category
  belongs_to :owner, counter_cache: true, class_name: "User"
  belongs_to :facility
  belongs_to :resolution_unit, class_name: "Unit"

  has_many :user_messages, as: :topic
  has_many :images, -> { where(category: FileAttachment::Categories::IMAGE) }, class_name: "FileAttachment", as: :attachable
  has_many :documents, -> { where(category: FileAttachment::Categories::DOCUMENT) }, class_name: "FileAttachment", as: :attachable
  has_many :tool_prices, dependent: :destroy, inverse_of: :tool

  belongs_to :terms_document

  accepts_nested_attributes_for :images,      allow_destroy: true
  accepts_nested_attributes_for :documents,   allow_destroy: true
  accepts_nested_attributes_for :tool_prices, allow_destroy: true, reject_if: :tool_price_rejected?
  accepts_nested_attributes_for :facility,    allow_destroy: true, reject_if: :facility_rejected?

  before_save :update_search_document
  after_validation :geocode
  geocoded_by :full_street_address

  validates :model_name,
            :manufacturer_name,
            :tool_category_name,
            :owner,
            :condition,
            :access_type,
            presence: true

  validate :has_at_least_one_tool_price

  DEFAULT_SAMPLE_SIZE = [ -4, 4 ]

  after_initialize :set_default_values

  module Condition
    EXCELLENT = "excellent"
    GOOD      = "good"
    FAIR      = "fair"
    POOR      = "poor"

    DEFAULT   = EXCELLENT

    ALL = [ EXCELLENT, GOOD, FAIR, POOR ]
    COLLECTION = ALL.map {|k| [ I18n.t("tools.condition.#{k}"), k ]}
  end

  module AccessType
    NONE    = "none"
    PARTIAL = "partial"
    FULL    = "full"

    DEFAULT = NONE

    ALL = [ NONE, PARTIAL, FULL ]
    COLLECTION = ALL.map {|k| [ I18n.t("tools.access_type.#{k}"), k ]}
  end

  module PriceType
    PER_TIME   = "time"
    PER_SAMPLE = "sample"

    DEFAULT = PER_SAMPLE

    ALL = [ PER_SAMPLE, PER_TIME ]
    COLLECTION = ALL.map {|k| [ I18n.t("tools.price_type.#{k}"), k ]}
  end

  delegate :address, to: :facility, allow_nil: true
  delegate :full_street_address, :partial_address, to: :address, allow_nil: true
  name_delegator :manufacturer, :model, :tool_category

  scope :live, -> { where(online: true) }
  scope :offline, -> { where(online: false) }
  
  def display_name
    "#{manufacturer_name} #{model_name}"
  end

  def possible_years
    Date.today.year.downto(1970).to_a
  end

  def owned_by?(user)
    user == self.owner
  end

  def tool_price_for(subtype=nil)
    subtype.blank? ? self.lowest_price : self.tool_prices.where(subtype: subtype)
  end

  def lowest_price
    self.tool_prices.min {|p| p.base_amount}
  end

  def price_for(deadline, samples, subtype=nil)
    self.tool_price_for(subtype).price_for(deadline, samples)
  end

  def sample_size_unit
    Unit.where(self.sample_size_unit_id).first
  end

  def sample_size_unit_name
    sample_size_unit.try :name
  end

  def resolution_unit_name
    resolution_unit.try :name
  end

  def resolution_with_unit
    if resolution.present? && tool.has_resolution?
      "#{self.resolution} #{self.resolution_unit_name}"
    end
  end

  def earliest_bookable_date
    lowest_price.try(:earliest_bookable_date)
  end

  def tool_prices_for_json(build)
    if build
      self.tool_prices.build; self.tool_prices
    else
      self.tool_prices
    end
  end

  def possible_terms_documents
    self.owner.terms_documents
  end

  def current_renter
    bookings.rented.first.try(:renter)
  end

  def to_json_for_build
    to_json(build: true)
  end

  def as_json(options={})
    options = options.merge(
      methods: [
        :model_name,
        :tool_category_name,
        :manufacturer_name,
        :images,
        :documents,
        :errors,
        :earliest_bookable_date,
        :possible_terms_documents
      ]
    )

    super(options).merge(
      sample_size: {
        min: self.sample_size_min,
        max: self.sample_size_max,
        unit: self.sample_size_unit,
        all: SampleSize.all_sizes,
      },
      tool_prices: tool_prices_for_json(options[:build]),
      tool_price_categories: ToolPrice::Subtype::COLLECTION
    )
  end

  def sandbox_listing
    self.online = false
    save(validate: false)
  end

  def go_live_with_listing
    self.online = true
    save
  end

  private

  def update_search_document
    self.document = [
      self.tool_category_name,
      self.manufacturer_name,
      self.model_name,
      self.description,
      self.serial_number,
    ].compact.join(" ")
  end

  def set_default_values
    min, max = DEFAULT_SAMPLE_SIZE
    self.sample_size_min ||= min
    self.sample_size_max ||= max
    self.condition       ||= Tool::Condition::DEFAULT
    self.price_type      ||= Tool::PriceType::DEFAULT
  end

  def facility_rejected?(attrs)
    attrs[:address_attributes][:address_line_1].blank?
  end

  def tool_price_rejected?(attrs)
    attrs[:subtype].blank? || attrs[:base_amount].blank? || attrs[:lead_time_days].blank?
  end

  def has_at_least_one_tool_price
    if tool_prices.empty?
      errors.add(:base, 'You must fill out the pricing info.')
    end
  end

end
