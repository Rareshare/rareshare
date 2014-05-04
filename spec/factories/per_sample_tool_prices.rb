FactoryGirl.define do
  factory :per_sample_tool_price do
    subtype PerSampleToolPrice::Subtype::BENCH_STANDARD
    base_amount BigDecimal.new("10.0")
    lead_time_days 10
    expedite_time_days 1
  end
end