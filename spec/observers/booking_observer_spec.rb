require 'spec_helper'

describe BookingObserver do
  let(:observer) { BookingObserver.instance }

  context 'logs' do
    context 'new booking' do
      let(:booking) { create(:booking) }
      before { observer.after_save(booking) }

      subject { booking.booking_logs.first }

      its(:state) { should eq("pending") }
      its(:updated_by) { should eq(booking.last_updated_by) }
    end

    context 'updated booking' do
      let(:booking) { create(:booking) }
      before {
        observer.after_save(booking)
        booking.updated_by = booking.last_updated_by
        booking.confirm!
        observer.after_save(booking)
      }

      subject { booking.booking_logs.last }

      its(:state) { should eq("confirmed") }
      its(:old_state) { should eq("pending") }
      its("log.size") { should eq(1) }
    end
  end
end
