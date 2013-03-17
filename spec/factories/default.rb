FactoryGirl.define do
  factory :manufacturer do
    name "Venture Indutries"
  end

  factory :model do
    name "Walking Eye"
    manufacturer
  end

  factory :tool do
    model
    resolution "Large"
    sample_size "Small"
    base_price 200.00
  end

  factory :user do
    sequence(:email) {|n| "person#{n}@example.com" }
    confirmed_at { Time.now }
    password { "password" }
  end

  factory :lease do
    association :lessor, factory: :user
    association :lessee, factory: :user
    tool
    description "Destroy all humans"
    tos_accepted true
    started_at { Date.today }
    ended_at { Date.today }
  end
end
