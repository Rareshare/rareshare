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
end
