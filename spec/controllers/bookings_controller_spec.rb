require 'spec_helper'

describe BookingsController do
  Given(:owner)    { create :user }
  Given(:renter)   { create :user }
  Given(:tool)     { create :tool, owner: owner }

  context "GET#new" do
    Given(:params)   { { tool_id: tool.id } }
    Given(:response) { get :new, params }
    Given(:booking)  { response; assigns :booking }

    context "without logging in" do
      Then { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when logged in as the owner" do
      When { sign_in owner }
      Then { expect(response).to redirect_to(profile_path) }
    end

    context "when logged in as a renter" do
      When { sign_in renter }
      Then { expect(response).to render_template("new") }
    end

    context "handling params" do
      Given { sign_in renter }

      context "without a tool" do
        Given { params[:tool_id] = nil }
        Then  { expect { response }.to raise_error(ActionController::RoutingError) }
      end

      context "without a date" do
        Then { expect(booking.deadline).to eq(tool.earliest_bookable_date) }
      end

      context "with a date" do
        When { params[:date] = 7.days.from_now }
        Then { expect(booking.deadline).to eq(7.days.from_now.to_date) }
      end
    end
  end

  context "PUT#create" do
    Given(:params)   { attributes_for(:booking).merge(tool_id: tool.id) }
    Given(:response) { post :create, booking: params }
    Given(:booking)  { create :booking, params }

    context "without logging in" do
      Then { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when logged in as the owner" do
      When { Booking.stub(:reserve).and_return booking }
      When { sign_in owner }
      Then { expect(response).to redirect_to(profile_path) }
    end

    context "with a valid booking" do
      When { Booking.stub(:reserve).and_return booking }
      When { sign_in renter }
      Then { expect(response).to redirect_to(booking_path(booking)) }
    end
  end

  context "POST#update" do
  end

end
