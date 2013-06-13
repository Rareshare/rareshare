require 'spec_helper'

describe "booking a tool", type: :feature, js: true do

  def login_manually_as(user_or_user_params)
    user = if user_or_user_params.is_a?(User)
      user_or_user_params
    else
      create(:user, user_or_user_params).tap { |u| u.confirm! }
    end

    visit new_user_session_path

    within "#new_user" do
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in', exact: true
    end

    user
  end

  def click_nav_link(name)
    within(".alt-navbar") { click_link name }
  end

  def fill_in_wysihtml5(label, opts={})
    page.execute_script <<-JAVASCRIPT
      var id = $("label:contains(#{label})").attr("for");
      $("#" + id).data("wysihtml5").editor.setValue("#{opts[:with]}");
    JAVASCRIPT
  end

  let(:renter) { create(:user) }
  let(:owner)  { create(:user) }

  def create_a_tool
    login_as owner; visit profile_path

    click_nav_link "Share a Tool"

    within "#new_tool" do
      fill_in "Category",         with: "Biology"
      fill_in "Manufacturer",     with: "OmniCorp"
      fill_in "Model",            with: "Splicer 3000"

      fill_in "Lead time - days", with: 10
      fill_in "Price",            with: 300

      fill_in "Address line 1",   with: "100 E 1st St"
      select  "United States",    from: "Country"
      fill_in "Town/City",        with: "New York"
      fill_in "Postal/Zip code",  with: "10003"

      click_button "Create Tool"
    end
  end

  def find_and_book_a_tool
    login_as renter; visit profile_path

    click_nav_link "Find a Tool"

    within "form.search-tools" do
      fill_in "q",    with: "OmniCorp Splicer 3000"
      find("input[name=by]").click
      fill_in "loc",  with: "New York"

      click_button "Search"
    end

    tool = Tool.first

    within "#tool_#{tool.id}" do
      click_link "Reserve"
    end

    within "form.new_booking" do
      fill_in_wysihtml5 "Sample description", with: "Radioactive Kryptonite"
      fill_in_wysihtml5 "Sample deliverable", with: "Body of Superman"
      select I18n.t("bookings.sample_transit.rareshare_send"), from: "Sample transit"

      fill_in "Address line 1",   with: "200 W 2ndt St"
      select  "United States",    from: "Country"
      fill_in "Town/City",        with: "New York"
      fill_in "Postal/Zip code",  with: "10004"

      select I18n.t("bookings.sample_disposal.rareshare_send"), from: "Sample disposal"

      check "I have read and agree to the Terms & Conditions for this booking."

      click_button "Reserve"
      sleep 10
    end
  end

  it "should log in, make a reservation, and finalize it" do
    create_a_tool
    find_and_book_a_tool
  end

end
