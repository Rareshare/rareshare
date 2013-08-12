require 'spec_helper'

describe User do

  context "for administration purposes" do
    specify { expect(User.administrative).to be_valid }
  end

  context "when integrating with LinkedIn" do
    context "and the user already exists" do
      context "and is already tied to a LinkedIn account" do
        Given(:user) { create :user, provider: "linkedin" }
        When(:oauth) { double(info: double(email: user.email)) }
        Then { expect(User.find_for_linkedin_oauth(oauth)).to eq(user) }
      end

      context "and isn't tied to a LinkedIn account" do
        Given(:user) { create :user }
        Given(:oauth) {
          double(
            provider: "linkedin",
            uid: "1234",
            info: double(
              email: user.email,
              image: "image.png",
              urls: double(public_profile: "/profile")
            )
          )
        }

        When(:found_user) { User.find_for_linkedin_oauth(oauth) }
        Then { expect(found_user.provider).to eq("linkedin") }
        And  { expect(found_user.uid).to eq("1234") }
        And  { expect(found_user.linkedin_profile_url).to eq("/profile") }
        And  { expect(found_user.image_url).to eq("image.png") }
      end
    end

    context "and the user has changed their email address" do
      Given(:user) { create :user, email: "test@example.com", provider: "linkedin", uid: "1234" }
      Given(:oauth) { double(provider: "linkedin", uid: "1234", info: double(email: "test2@example.com")) }
      When(:found_user) { user; User.find_for_linkedin_oauth(oauth) }
      Then { expect(found_user.email).to eq("test2@example.com") }
    end

    context "and the user is joining for the first time"
  end
end
