require 'spec_helper'

describe Booking do
  include EasyPost::Stubs

  describe '#state' do
    context 'initial' do
      subject { Booking.new }
      its(:state) { should eq("pending") }
    end
  end

  describe '#last_updated_by' do
    context 'initial' do
      specify { subject.should have(1).error_on(:updated_by) }
    end

    context 'with updated_by' do
      let(:user) { create(:user) }
      subject { Booking.new(updated_by: user) }
      specify { subject.should have(0).errors_on(:updated_by) }
    end

    context 'after save' do
      let(:user) { create(:user) }
      subject { create(:booking, updated_by: user) }
      its(:last_updated_by) { should eq(user) }
    end
  end

  context 'sample shipping' do
    context 'required' do
      subject { build(:booking, sample_transit: Booking::Transit::RARESHARE_SEND, sample_disposal: Booking::Disposal::RARESHARE_SEND) }
      its(:ship_outgoing?) { should be_true }
      its(:ship_return?) { should be_true }
    end

    context 'not required' do
      subject { build(:booking, sample_transit: Booking::Transit::IN_PERSON, sample_disposal: Booking::Disposal::IN_PERSON) }
      its(:ship_outgoing?) { should be_false }
      its(:ship_return?) { should be_false }
    end

    context 'outgoing' do
      before { stub_easypost }

      let(:tool)    { create(:tool, owner: owner) }
      let(:renter)  { create(:user, address: create(:address)) }
      let(:owner)   { create(:user) }
      let(:booking) {
        Booking.reserve(renter,
          use_user_address: true,
          sample_transit: Booking::Transit::RARESHARE_SEND,
          tool: tool,
          shipping_package_size: Booking::PackageSize::PAK,
          deadline: (tool.base_lead_time + 2).days.from_now
        )
      }

      subject { booking.outgoing_shipment }

      specify {
        subject.to_address.name.should eq(owner.display_name)
        subject.from_address.name.should eq(renter.display_name)
        subject.parcel.predefined_package.should eq(Booking::PackageSize::PAK)
      }
    end
  end

  context '.reserve' do
    let(:tool)     { create(:tool, base_lead_time: 7, base_price: 200.0) }
    let(:renter)   { create(:user) }
    let(:deadline) { 7.days.from_now }
    let(:params)   { { tool_id: tool.id, deadline: deadline } }
    subject { Booking.reserve renter, params }

    context 'pricing' do
      its(:price) { should eq 200.0 }
      its(:rareshare_fee) { should eq(200.0 * Booking::RARESHARE_FEE_PERCENT) }
    end

    context 'address' do
      let(:renter) { create(:user, address: create(:address)) }

      context 'without shipping' do
        before { params.merge! use_user_address: true, sample_transit: Booking::Transit::IN_PERSON }
        its(:address) { should be_nil }
      end

      context 'with shipping, with user' do
        before { params.merge! use_user_address: true, sample_transit: Booking::Transit::RARESHARE_SEND }
        its(:address) { should eq renter.address }
      end
    end
  end

end
