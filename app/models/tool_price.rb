class ToolPrice < ActiveRecord::Base
  module Subtype
    BENCH_STANDARD = "bench_standard"
    GMP            = "gmp"
    GLP            = "glp"
    CLIA           = "clia"
    ISO9000        = "iso_9000"
    ISO13485       = "iso_13485"
    ISO14000       = "iso_14000"

    ALL = [ BENCH_STANDARD, GMP, GLP, CLIA, ISO9000, ISO13485, ISO14000 ]
    COLLECTION = ALL.map {|k| [ I18n.t("tool_prices.subtype.#{k}"), k ]}
  end

  validates :tool_id, :subtype, :base_amount, presence: true
  validates :tool_id, uniqueness: { scope: [:subtype] }
  validates :subtype, inclusion: { in: ToolPrice::Subtype::ALL }

  ZERO = BigDecimal.new('0.0')

  def requires_setup?
    self.setup_amount.present? && self.setup_amount > ZERO
  end

  def can_expedite?
    self.expedite_time_days.present? && self.expedite_time_days.nonzero?
  end

  def expedite_amount
    self.base_amount + ( self.base_amount / 2 )
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

  def price_for(deadline, samples)
     base_price_for(deadline, samples) + setup_price
  end

  def minimum_future_lead_time
    [ lead_time_days, expedite_time_days ].compact.min
  end

  def samples_per_run
    1
  end

  private

  def days_to_deadline(deadline)
    deadline = Date.parse(deadline) if deadline.is_a?(String)
    deadline = deadline.to_date if !deadline.is_a?(Date)
    ( deadline - Date.today ).to_i
  end

end
