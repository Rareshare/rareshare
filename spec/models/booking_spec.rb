require 'spec_helper'

describe Booking do
  include EasyPost::Stubs

  Given(:booking) { create :booking }

  context "with no changes" do
    Then { expect(booking.state).to eq "pending" }
    And  { expect(booking).to be_valid }
  end

  context "when performing updates to the booking" do
    Given(:reloaded_booking) { Booking.find(booking.id) }

    context "with no updated_by user" do
      Then { expect(reloaded_booking).to have(1).error_on(:updated_by) }
    end

    context "with an updated_by user" do
      When { reloaded_booking.updated_by = booking.owner }
      Then { expect(reloaded_booking).to have(0).errors_on(:updated_by) }

      context "on a successful save" do
        When { reloaded_booking.save! }
        Then { expect(reloaded_booking.last_updated_by).to eq booking.owner }
      end
    end
  end

  context "when handling sample delivery" do
    context "without shipping" do
      Then { expect(booking).to_not be_ship_outgoing }
      And  { expect(booking).to_not be_ship_return }
    end

    context "with shipping required" do
      context "outgoing" do
        When { booking.sample_transit = Booking::Transit::RARESHARE_SEND }
        Then { expect(booking).to be_ship_outgoing }
      end

      context "return" do
        When { booking.sample_disposal = Booking::Disposal::RARESHARE_SEND }
        Then { expect(booking).to be_ship_return }
      end

      context "when calculating rates" do
        Given { stub_easypost }
        When { booking.address = create(:address) }
        When { booking.shipping_package_size = Booking::PackageSize::PAK }
        When { booking.sample_transit = Booking::Transit::RARESHARE_SEND }
        When(:shipment) { booking.outgoing_shipment }
        Then { expect(shipment.to_address.name).to eq booking.owner.display_name }
        And  { expect(shipment.from_address.name).to eq booking.renter.display_name }
        And  { expect(shipment.parcel.predefined_package).to eq Booking::PackageSize::PAK }
      end
    end
  end

  context "upon reserving" do
    Given(:tool)     { create(:tool) }
    Given(:owner)    { tool.owner }
    Given(:renter)   { create(:user) }
    Given(:deadline) { 7.days.from_now }
    Given(:params)   {
      attributes_for(:booking)
        .slice(
          :sample_description,
          :sample_deliverable,
          :sample_transit,
          :sample_disposal,
          :tos_accepted
        ).merge(tool_id: tool.id, deadline: deadline, samples: 1)
    }

    Given(:booking) { Booking.reserve renter, params }
    Then { expect(booking).to be_valid }
    And  { expect(booking.currency).to eq tool.currency }
    And  { expect(booking.renter).to eq renter }
    And  { expect(booking.owner).to eq owner }

    context "when calculating the booking fee" do
      Given(:base_price) { BigDecimal.new("200.00") }
      When { tool.stub(:price_for).and_return base_price }
      Then { expect(booking.rareshare_fee).to eq(base_price * Booking::RARESHARE_FEE_PERCENT) }
    end

    context "when calculating the address" do
      context "and no shipping is required" do
        Then { expect(booking.address).to be_nil }
      end

      context "and the user's address has been requested" do
        Given(:an_address) { build :address }
        When { renter.address = an_address }
        When { params[:use_user_address] = true }
        When { params[:sample_transit] = Booking::Transit::RARESHARE_SEND }
        Then { expect(booking.address).to eq an_address }
      end
    end
  end
end
