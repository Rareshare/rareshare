FactoryGirl.define do
  factory :user do
    first_name "Tester"
    sequence(:last_name) { |n| "Person#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    confirmed_at { Time.now }
    tos_accepted true
    password "password"
    admin_approved true
    # tos_accepted true
    # confirmed_at DateTime.now
  end
end