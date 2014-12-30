FactoryGirl.define do
  factory :tool do
    model
    manufacturer
    tool_category
    facility
    association :owner, factory: :user
    currency "USD"
    samples_per_run 10
    access_type Tool::AccessType::FULL
    online true

    before(:create) do |tool|
      tool.per_sample_tool_prices << create(:per_sample_tool_price, tool: tool)
    end
  end
end
