require 'spec_helper'

describe Tool do
  describe "name delegators" do
    subject { create(:tool) }

    describe "#model_name" do
      before { subject.update_attributes(model_name: "Some model") }
      its(:model) { should eq Model.where(name: "Some model").first }
    end

    describe "#manufacturer_name" do
      before { subject.update_attributes(manufacturer_name: "Some manufacturer") }
      its(:manufacturer) { should eq Manufacturer.where(name: "Some manufacturer").first }
    end

    describe "#tool_category_name" do
      before { subject.update_attributes(tool_category_name: "Some tool_category") }
      its(:tool_category) { should eq ToolCategory.where(name: "Some tool_category").first }
    end
  end

  describe "#display_name" do
    subject { build(:tool, manufacturer_name: "RareShare", model_name: "Killbot 3000") }
    its(:display_name) { should eq "RareShare Killbot 3000" }
  end

  describe "on creation" do
    subject { build(:tool) }
    its(:address) { should_not be_blank }
  end

  describe "#bookable_by?" do
    context "base lead time only" do
      let(:tool) { build(:tool, base_lead_time: 7) }
      subject { tool.bookable_by?(deadline) }
      context { let(:deadline) { 5.days.from_now }; it { should be_false } }
      context { let(:deadline) { 7.days.from_now }; it { should be_false } }
      context { let(:deadline) { 9.days.from_now }; it { should be_true  } }
    end

    context "with expedited lead time" do
      let(:tool) { build(:tool, base_lead_time: 7, expedited_lead_time: 4) }
      subject { tool.bookable_by?(deadline) }
      context { let(:deadline) { 3.days.from_now }; it { should be_false } }
      context { let(:deadline) { 4.days.from_now }; it { should be_false } }
      context { let(:deadline) { 5.days.from_now }; it { should be_true } }
      context { let(:deadline) { 7.days.from_now }; it { should be_true  } }
    end
  end

  describe "#must_expedite?" do
    context "base lead time only" do
      let(:tool) { build(:tool, base_lead_time: 7) }
      subject { tool.must_expedite?(deadline) }
      context { let(:deadline) { 5.days.from_now }; it { should be_false } }
      context { let(:deadline) { 7.days.from_now }; it { should be_false } }
      context { let(:deadline) { 9.days.from_now }; it { should be_false } }
    end

    context "with expedited lead time" do
      let(:tool) { build(:tool, base_lead_time: 7, expedited_lead_time: 4) }
      subject { tool.must_expedite?(deadline) }
      context { let(:deadline) { 3.days.from_now }; it { should be_false } }
      context { let(:deadline) { 5.days.from_now }; it { should be_true  } }
      context { let(:deadline) { 7.days.from_now }; it { should be_true  } }
      context { let(:deadline) { 9.days.from_now }; it { should be_false } }
    end
  end
end
