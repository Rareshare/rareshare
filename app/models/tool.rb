class Tool < ActiveRecord::Base
  extend NameDelegator

  has_many :bookings
  has_one :address, as: :addressable

  belongs_to :owner, class_name: "User"
  belongs_to :model
  belongs_to :manufacturer
  belongs_to :tool_category
  belongs_to :user, counter_cache: true, foreign_key: :owner_id
  belongs_to :facility

  has_many :user_messages, as: :topic
  has_many :file_attachments, as: :attachable
  accepts_nested_attributes_for :file_attachments, allow_destroy: true

  after_initialize :build_address_if_blank
  before_save :update_search_document
  after_validation :geocode
  geocoded_by :full_street_address

  validates :model_name,
            :manufacturer_name,
            :tool_category_name,
            :owner,
            :base_lead_time,
            :base_price,
            presence: true

  validates :expedited_price,
            :expedited_lead_time,
            presence: true,
            if: :can_expedite?

  validates :base_lead_time,
            :expedited_lead_time,
            :resolution,
            numericality: { greater_than: 0, allow_nil: true }

  accepts_nested_attributes_for :address, allow_destroy: true

  DEFAULT_SAMPLE_SIZE = [ -4, 4 ]
  after_initialize :set_default_sample_size

  scope :bookable_by, lambda {|deadline|
    days_to_deadline = ( deadline - Date.today ).to_i
    where("LEAST(base_lead_time, expedited_lead_time) < ?", days_to_deadline)
  }

  delegate :full_street_address, :partial_address, to: :address
  name_delegator :manufacturer, :model, :tool_category

  def display_name
    "#{manufacturer_name} #{model_name}"
  end

  def possible_years
    [""] + Date.today.year.downto(1970).to_a
  end

  def owned_by?(user)
    user == self.owner
  end

  def bookable_by?(deadline)
    [ base_lead_time, expedited_lead_time ].compact.min < days_to_deadline(deadline)
  end

  def must_expedite?(deadline)
    bookable_by?(deadline) && base_lead_time >= days_to_deadline(deadline)
  end

  def price_for(deadline)
    must_expedite?(deadline) ? expedited_price : base_price
  end

  def sample_size_unit
    Unit.definitions[self.sample_size_unit_id]
  end

  def resolution_unit
    Unit.definitions[self.resolution_unit_id]
  end

  def sample_size_unit_name
    sample_size_unit.try :display_name
  end

  def resolution_unit_name
    resolution_unit.try :display_name
  end

  def images
    file_attachments.where(category: FileAttachment::Categories::IMAGE)
  end

  def as_json(options={})
    options = options.merge(
      methods: [:model_name, :tool_category_name, :manufacturer_name, :images, :errors]
    )

    super(options).merge(
      sample_size: {
        min: self.sample_size_min,
        max: self.sample_size_max,
        unit: self.sample_size_unit,
        all: SampleSize.all_sizes
      }
    )
  end

  private

  def build_address_if_blank
    build_address if self.address.blank?
  end

  def update_search_document
    self.document = [
      self.tool_category_name,
      self.manufacturer_name,
      self.model_name,
      self.description,
      self.serial_number,
    ].compact.join(" ")
  end

  def set_default_sample_size
    min, max = DEFAULT_SAMPLE_SIZE
    self.sample_size_min ||= min
    self.sample_size_max ||= max
  end

  def days_to_deadline(deadline)
    deadline = Date.parse(deadline) if deadline.is_a?(String)
    deadline = deadline.to_date if !deadline.is_a?(Date)
    ( deadline - Date.today ).to_i
  end
end
