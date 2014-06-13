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

  factory :unit do
    name "m"
    label "meters"
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
    deadline { 2.weeks.from_now }
    updated_by { create(:user) }
    units 1
  end
end
