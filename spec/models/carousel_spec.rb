require 'spec_helper'

describe Carousel do
  let(:carousel) { build(:carousel) }

  describe "DB columns" do
    expect_it { to have_db_column(:image).of_type(:string) }
    expect_it { to have_db_column(:resource_type).of_type(:string) }
    expect_it { to have_db_column(:resource_id).of_type(:integer) }
    expect_it { to have_db_column(:active).of_type(:boolean) }
    expect_it { to have_db_column(:external_link).of_type(:string) }
    expect_it { to have_db_column(:external_link_title).of_type(:string) }
    expect_it { to have_db_column(:custom_content).of_type(:text) }
  end

  describe "Associations" do
    expect_it { to belong_to(:tool).with_foreign_key(:resource_id) }
  end

  describe "Validations" do
    expect_it { to validate_presence_of(:image) }

    it "validates linkability" do
      expect(carousel).to receive(:linkable)
      carousel.save
    end

    describe "linkable" do
      context "resource_type, resource_id, external_link, and cusotm_content are nil" do
        let(:carousel) { Carousel.new() }

        it "adds error" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).to include("must have linkable content.")
        end
      end

      context "resource_type and resource_id are present" do
        let(:carousel) { Carousel.new(resource_type: 'Tool', resource_id: 1) }

        it "does not add erorr" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).not_to include("must have linkable content.")
        end
      end

      context "only resource_type is present" do
        let(:carousel) { Carousel.new(resource_type: 'Tool') }

        it "adds error" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).to include("must have linkable content.")
        end
      end

      context "only resource_id is present" do
        let(:carousel) { Carousel.new(resource_id: 1) }

        it "adds error" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).to include("must have linkable content.")
        end
      end

      context "external_link and external_link_title are present" do
        let(:carousel) { Carousel.new(external_link: 'link', external_link_title: 'title') }

        it "does not add erorr" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).not_to include("must have linkable content.")
        end
      end

      context "only external_link is present" do
        let(:carousel) { Carousel.new(external_link: 'link') }

        it "adds error" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).to include("must have linkable content.")
        end
      end

      context "only external_link_title is present" do
        let(:carousel) { Carousel.new(external_link_title: "title") }

        it "adds error" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).to include("must have linkable content.")
        end
      end

      context "custom_content is present" do
        let(:carousel) { Carousel.new(custom_content: "content") }

        it "does not add erorr" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).not_to include("must have linkable content.")
        end
      end
    end # linkable

    describe "external link format validation" do
      expect_it { to allow_value('http://foo.com', 'http://bar.com/baz').for(:external_link) }
      expect_it { not_to allow_value('asdfjkl').for(:external_link) }
    end
  end # Validations

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