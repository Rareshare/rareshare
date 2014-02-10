class Tool < ActiveRecord::Base
  extend NameDelegator

  BULK_DISCOUNT = BigDecimal.new("0.80")

  has_many :bookings

  belongs_to :owner, class_name: "User"
  belongs_to :model
  belongs_to :manufacturer
  belongs_to :tool_category
  belongs_to :user, counter_cache: true, foreign_key: :owner_id
  belongs_to :facility

  has_many :user_messages, as: :topic
  has_many :file_attachments, as: :attachable
  has_many :tool_prices, dependent: :destroy, inverse_of: :tool

  belongs_to :terms_document

  accepts_nested_attributes_for :file_attachments, allow_destroy: true
  accepts_nested_attributes_for :tool_prices,      allow_destroy: true, reject_if: :tool_price_rejected?
  accepts_nested_attributes_for :facility,         allow_destroy: true, reject_if: :facility_rejected?

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

  scope :bookable_by, lambda {|deadline|
    days_to_deadline = ( deadline - Date.today ).to_i
    where("LEAST(base_lead_time, expedited_lead_time) < ?", days_to_deadline)
  }

  delegate :address, to: :facility
  delegate :full_street_address, :partial_address, to: :address
  name_delegator :manufacturer, :model, :tool_category

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

  def resolution_unit
    Unit.where(self.resolution_unit_id).first
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

  def images
    file_attachments.where(category: FileAttachment::Categories::IMAGE)
  end

  def earliest_bookable_date
    lowest_price.try(:earliest_bookable_date)
  end

  def tool_prices_for_edit
    self.tool_prices.build; self.tool_prices
  end

  def possible_terms_documents
    self.owner.terms_documents
  end

  def as_json(options={})
    options = options.merge(
      methods: [
        :model_name,
        :tool_category_name,
        :manufacturer_name,
        :images,
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
      tool_prices: tool_prices_for_edit,
      tool_price_categories: ToolPrice::Subtype::COLLECTION
    )
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

end
