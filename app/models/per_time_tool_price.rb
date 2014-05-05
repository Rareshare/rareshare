class PerTimeToolPrice < ActiveRecord::Base
  module TimeUnit
    DAY = "day"
    HOUR   = "hour"

    DEFAULT = DAY

    ALL = [ DAY, HOUR ]
    COLLECTION = ALL.map {|k| [ I18n.t("tool_prices.time_unit.#{k}"), k ]}
  end

  ZERO = BigDecimal.new('0.0')

  after_initialize :set_default_values

  belongs_to :tool, inverse_of: :per_time_tool_price
  has_many :bookings, as: :tool_price
  
  validates_presence_of :tool, :time_unit, :amount_per_time_unit
  validates_numericality_of :expedite_time_days, less_than_or_equal_to: :lead_time_days, allow_blank: true, message: "must be less than lead time days"

  def set_default_values
    self.time_unit      ||= PerTimeToolPrice::TimeUnit::DEFAULT
  end

  def price_for

  end

  def revised_price_for(units, opts={})
    price   = opts[:expedited] ? expedite_amount : amount_per_time_unit
    setup_price + ( price * units )
  end

  def setup_price
    self.setup_amount || ZERO
  end

  def requires_setup?
    self.setup_amount.present? && self.setup_amount > ZERO
  end
  alias_method :requires_setup, :requires_setup?

  def can_expedite?
    !!(self.expedite_time_days.present? && self.expedite_time_days.nonzero?)
  end
  alias_method :can_expedite, :can_expedite?

  def earliest_bookable_date
    ( lead_time_days || 0 ).days.from_now.to_date
  end

  def earliest_expedite_date
    ( expedite_time_days || 0 ).days.from_now.to_date if can_expedite?
  end

  def expedite_amount
    amount_per_time_unit * 1.5
  end


  def as_json(options={})
    super options.merge(
            methods: [
              :setup_price,
              :expedite_price,
              :can_expedite,
              :expedite_amount
            ]
          )
  end
end