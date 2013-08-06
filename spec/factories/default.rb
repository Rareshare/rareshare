FactoryGirl.define do
  factory :manufacturer do
    sequence(:name) { |n| "Venture Industries #{n}" }
  end

  factory :model do
    sequence(:name) { |n| "Walking Eye #{n}" }
    manufacturer
  end

  factory :tool_category do
    sequence(:name) {|n| "Robots #{n}" }
  end

  factory :address do
    sequence(:address_line_1) {|n| "#{n} Venture Way" }
    city "Bozeman"
    state "MO"
    postal_code 59715
    country "US"
  end

  factory :facility do
    sequence(:name) { |n| "Facility #{n}" }
    address
  end

  factory :tool do
    model
    manufacturer
    tool_category
    facility
    can_expedite false
    can_bulkify false
    association :owner, factory: :user
    resolution 10
    resolution_unit_id { AvailableUnit.for("<meter>") }
    currency "USD"
    base_price 200.00
    base_lead_time 7
    samples_per_run 10

    factory :premium_tool do
      can_expedite true
      base_price 2000.00
      expedited_price 2500.00
      expedited_lead_time 3
      can_bulkify true
      bulk_runs 5
    end
  end

  factory :user do
    first_name "Tester"
    sequence(:last_name) { |n| "Person#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    confirmed_at { Time.now }
    password { "password" }
  end

  factory :booking do
    association :renter, factory: :user
    tool
    sample_description "Kryptonite"
    sample_deliverable "Processed Kryptonite"
    sample_transit Booking::Transit::IN_PERSON
    sample_disposal Booking::Disposal::IN_PERSON
    tos_accepted true
    currency "USD"
    price BigDecimal.new("10000.00")
    rareshare_fee BigDecimal.new("1000.00")
    deadline { 2.weeks.from_now }
    updated_by { create(:user) }
    samples 1
  end
end
