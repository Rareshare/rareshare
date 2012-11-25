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
    technician_required false
    price_per_hour 200
  end
end