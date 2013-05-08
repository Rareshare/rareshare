require 'spec_helper'

describe Booking do

  describe 'factory' do
    specify { build(:booking).should be_valid }
  end

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

end
