require 'spec_helper'

describe ToolPrice do
  context "when checking for bookability" do
    Given(:price) { create :tool_price, lead_time_days: 7 }

    context "with standard deadlines" do
      Then { expect(price).to_not be_bookable_by(5.days.from_now) }
      And  { expect(price).to_not be_bookable_by(7.days.from_now.to_date) }
      And  { expect(price).to     be_bookable_by(9.days.from_now) }
    end

    context "with expedited deadlines" do
      When { price.expedite_time_days = 4 }
      Then { expect(price).to_not be_bookable_by(3.days.from_now) }
      And  { expect(price).to_not be_bookable_by(4.days.from_now.to_date) }
      And  { expect(price).to     be_bookable_by(5.days.from_now) }
      And  { expect(price).to     be_bookable_by(7.days.from_now) }
    end
  end

  context "when checking for expeditability" do
    Given(:price) { create :tool_price, lead_time_days: 7 }

    context "with standard deadlines" do
      When { price.expedite_time_days = nil }
      Then { expect(price.must_expedite?(5.days.from_now)).to be false }
      And  { expect(price.must_expedite?(7.days.from_now)).to be false }
      And  { expect(price.must_expedite?(9.days.from_now)).to be false }
    end

    context "with expedited deadlines" do
      When { price.expedite_time_days = 4 }
      Then { expect(price.must_expedite?(3.days.from_now)).to be false }
      And  { expect(price.must_expedite?(5.days.from_now)).to be true  }
      And  { expect(price.must_expedite?(7.days.from_now)).to be true  }
      And  { expect(price.must_expedite?(9.days.from_now)).to be false }
    end
  end

  context "when calculating price" do
    Given(:price) { create :tool_price, base_amount: BigDecimal.new("10.00") }

    context "without expediting" do
      When { price.lead_time_days = 7 }

      Then { expect(price.price_for(8.days.from_now, 1)).to eq price.base_price }
      And  { expect(price.price_for(8.days.from_now, 5)).to eq(price.base_price * 5) }
    end

    context "with expediting" do
      When { price.lead_time_days = 7 }
      When { price.expedite_time_days = 5 }

      Then { expect(price.price_for(6.days.from_now, 1)).to eq price.expedite_price }
      And  { expect(price.price_for(8.days.from_now, 1)).to eq price.base_price }
    end
  end
end
