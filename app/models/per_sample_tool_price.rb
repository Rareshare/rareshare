class PerSampleToolPrice < ActiveRecord::Base
  module Subtype
    BENCH_STANDARD = "bench_standard"
    GMP            = "gmp"
    GLP            = "glp"
    CLIA           = "clia"
    ISO9000        = "iso_9000"
    ISO13485       = "iso_13485"
    ISO14000       = "iso_14000"
    OTHER          = "other"

    ALL = [ BENCH_STANDARD, GMP, GLP, CLIA, ISO9000, ISO13485, ISO14000, OTHER ]
    COLLECTION = ALL.map {|k| [ I18n.t("tool_prices.subtype.#{k}"), k ]}
  end

  belongs_to :tool, inverse_of: :per_sample_tool_prices
  has_many :bookings, as: :tool_price
  validates_presence_of :tool

  validates :subtype, :base_amount, presence: true
  validates :tool_id, uniqueness: { scope: [:subtype] }
  validates :subtype, inclusion: { in: PerSampleToolPrice::Subtype::ALL }
  validates_numericality_of :expedite_time_days, less_than_or_equal_to: :lead_time_days, allow_nil: true, message: "must be less than lead time days"

  ZERO = BigDecimal.new('0.0')

  def requires_setup?
    self.setup_amount.present? && self.setup_amount > ZERO
  end
  alias_method :requires_setup, :requires_setup?

  def can_expedite?
    !!(self.expedite_time_days.present? && self.expedite_time_days.nonzero?)
  end
  alias_method :can_expedite, :can_expedite?

  def expedite_amount
    base_amount * 1.5
  end

  def bookable_by?(deadline)
    minimum_future_lead_time < days_to_deadline(deadline)
  end

  def must_expedite?(deadline)
    can_expedite? && bookable_by?(deadline) && lead_time_days >= days_to_deadline(deadline)
  end

  def runs_required(samples)
    ( samples.to_i / self.samples_per_run.to_f ).ceil
  end

  def price_per_run_for(deadline, samples)
    must_expedite?(deadline) ? expedite_amount : base_amount
  end

  def base_price_for(deadline, samples)
    price_per_run_for(deadline, samples) * runs_required(samples)
  end

  def setup_price
    self.setup_amount || ZERO
  end

  def base_price
    setup_price + base_amount
  end

  def expedite_price
    ( setup_price + expedite_amount ) if can_expedite?
  end

  def price_for(deadline, samples)
     base_price_for(deadline, samples) + setup_price
  end

  def revised_price_for(units, opts={})
    price   = opts[:expedited] ? expedite_amount : base_amount
    setup_price + ( price * units )
  end

  def minimum_future_lead_time
    [ lead_time_days, expedite_time_days ].compact.min
  end

  def samples_per_run
    1
  end

  def earliest_bookable_date
    ( lead_time_days || 0 ).days.from_now.to_date
  end

  def earliest_expedite_date
    ( expedite_time_days || 0 ).days.from_now.to_date if can_expedite?
  end

  def label
    I18n.t("tool_prices.subtype.#{subtype}")
  end

  def as_json(options={})
    super options.merge(
      methods: [
        :earliest_bookable_date,
        :earliest_expedite_date,
        :samples_per_run,
        :minimum_future_lead_time,
        :setup_price,
        :base_price,
        :expedite_price,
        :requires_setup,
        :can_expedite,
        :expedite_amount,
        :label
      ]
    )
  end

  private

  def days_to_deadline(deadline)
    deadline = Date.parse(deadline) if deadline.is_a?(String)
    deadline = deadline.to_date if !deadline.is_a?(Date)
    ( deadline - Date.today ).to_i
  end

end
