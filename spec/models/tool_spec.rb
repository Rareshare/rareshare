require 'spec_helper'

describe Tool do
  Given(:tool) { create :tool }

  # TODO These can probably go into their own NameDelegator spec.
  context "nested models" do
    def id_of(model_class, name)
      model_class.where(name: name).pluck(:id).first
    end

    context "when setting model" do
      When { tool.update_attributes model_name: "Some model" }
      Then { expect(tool.model.id).to eq id_of(Model, "Some model") }
    end

    context "when setting manufacturer" do
      When { tool.update_attributes(manufacturer_name: "Some manufacturer") }
      Then { expect(tool.manufacturer.id).to eq id_of(Manufacturer, "Some manufacturer") }
    end

    context "when setting tool category" do
      When { tool.update_attributes(tool_category_name: "Some category") }
      Then { expect(tool.tool_category.id).to eq id_of(ToolCategory, "Some category") }
    end
  end

  context "when generating a name for display" do
    When { tool.manufacturer_name = "RareShare" }
    When { tool.model_name = "Killbot 3000" }
    Then { expect(tool.display_name).to eq "RareShare Killbot 3000" }
  end

  context "when checking for bookability" do
    When { tool.base_lead_time = 7 }

    context "with standard deadlines" do
      When { tool.expedited_lead_time = nil }
      Then { expect(tool).to_not be_bookable_by(5.days.from_now) }
      And  { expect(tool).to_not be_bookable_by(7.days.from_now) }
      And  { expect(tool).to     be_bookable_by(9.days.from_now) }
    end

    context "with expedited deadlines" do
      When { tool.expedited_lead_time = 4 }
      Then { expect(tool).to_not be_bookable_by(3.days.from_now) }
      And  { expect(tool).to_not be_bookable_by(4.days.from_now) }
      And  { expect(tool).to     be_bookable_by(5.days.from_now) }
      And  { expect(tool).to     be_bookable_by(7.days.from_now) }
    end
  end

  context "when checking for expeditability" do
    When { tool.base_lead_time = 7 }

    context "with standard deadlines" do
      When { tool.expedited_lead_time = nil }
      Then { expect(tool.must_expedite?(5.days.from_now)).to be false }
      And  { expect(tool.must_expedite?(7.days.from_now)).to be false }
      And  { expect(tool.must_expedite?(9.days.from_now)).to be false }
    end

    context "with expedited deadlines" do
      When { tool.expedited_lead_time = 4 }
      Then { expect(tool.must_expedite?(3.days.from_now)).to be false }
      Then { expect(tool.must_expedite?(5.days.from_now)).to be true  }
      Then { expect(tool.must_expedite?(7.days.from_now)).to be true  }
      Then { expect(tool.must_expedite?(9.days.from_now)).to be false }
    end
  end

  context "when calculating pricing" do
    Given { tool.base_lead_time = 7 }
    Given { tool.base_price = BigDecimal.new("10.00") }
    Given { tool.samples_per_run = 1 }

    context "without bulk or expediting" do
      When { tool.can_bulkify = false }
      When { tool.can_expedite = false }
      Then { expect(tool.price_for(8.days.from_now, 1)).to eq tool.base_price }
      And  { expect(tool.price_for(8.days.from_now, 5)).to eq(tool.base_price * 5) }

      context "with multiple samples per run" do
        When { tool.samples_per_run = 10 }
        Then { expect(tool.price_for(8.days.from_now, 1)).to eq(tool.base_price) }
        And  { expect(tool.price_for(8.days.from_now, 5)).to eq(tool.base_price) }
        And  { expect(tool.price_for(8.days.from_now, 15)).to eq(tool.base_price * 2) }
      end
    end
  end
end
