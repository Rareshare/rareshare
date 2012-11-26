require 'spec_helper'

describe Lease do

  context "after initialize" do
    its(:state) { should eq "pending" }
  end

  context "after save" do
    subject { build(:lease) }
    before { subject.save! }
    specify { subject.lessor.unread_message_count.should eq 1 }
  end

  context "transition to confirmed" do
    subject { create(:lease) }
    before { subject.confirm! }
    specify { subject.lessee.unread_message_count.should eq 1 }
  end

end