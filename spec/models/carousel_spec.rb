require 'spec_helper'

describe Carousel do
  describe "DB columns" do
    expect_it { to have_db_column(:image).of_type(:string) }
    expect_it { to have_db_column(:resource_type).of_type(:string) }
    expect_it { to have_db_column(:resource_id).of_type(:integer) }
    expect_it { to have_db_column(:active).of_type(:boolean) }
  end

  describe "Associations" do
    expect_it { to belong_to(:tool).with_foreign_key(:resource_id) }
  end

  describe "Validations" do
    expect_it { to validate_presence_of(:resource_type) }
    expect_it { to validate_presence_of(:resource_id) }
    expect_it { to validate_presence_of(:image) }
  end

  describe "Scopes" do
    describe "active" do
      let(:active_carousel) { build(:carousel, active: true) }
      let(:inactive_carousel) { build(:carousel, active: false) }

      before(:each) do
        active_carousel.save(validate: false)
        inactive_carousel.save(validate: false)
      end

      it "includes carousels that are active" do
        expect(Carousel.active).to include(active_carousel)
      end

      it "does not include carousels that are inactive" do
        expect(Carousel.active).not_to include(inactive_carousel)
      end
    end
  end

  describe "resource" do
    context "resource_type == 'Tool'" do
      let(:carousel) { build(:carousel, resource_type: 'Tool') }

      it "gets the tool it belongs to" do
        carousel.save(validate: false)
        expect(carousel.resource).to eql(carousel.tool)
      end
    end
  end
end