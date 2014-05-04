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
  validates_presence_of :tool
  validates_presence_of :time_unit

  def set_default_values
    self.time_unit      ||= PerTimeToolPrice::TimeUnit::DEFAULT
  end

  def requires_setup?
    self.setup_amount.present? && self.setup_amount > ZERO
  end
  alias_method :requires_setup, :requires_setup?
end