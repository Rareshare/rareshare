require 'spec_helper'

describe Carousel do
  let(:carousel) { build(:carousel) }

  describe "DB columns" do
    expect_it { to have_db_column(:image).of_type(:string) }
    expect_it { to have_db_column(:resource_type).of_type(:string) }
    expect_it { to have_db_column(:resource_id).of_type(:integer) }
    expect_it { to have_db_column(:active).of_type(:boolean) }
    expect_it { to have_db_column(:external_link_url).of_type(:string) }
    expect_it { to have_db_column(:external_link_text).of_type(:string) }
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
      context "resource, external_link, and custom_content are not present" do
        let(:carousel) { Carousel.new() }

        it "adds error" do
          carousel.send(:linkable)
          expect(carousel.errors.full_messages).to include("must have linkable content.")
        end
      end

      context "external_link and custom_content are not present" do
        context "resource is present" do
          it "does not add error" do
            expect(carousel).to receive(:resource_present?).and_return(true)
            carousel.send(:linkable)
            expect(carousel.errors.full_messages).not_to include("must have linkable content.")
          end
        end

        context "resource is not present" do
          it "adds error" do
            expect(carousel).to receive(:resource_present?).and_return(false)
            carousel.send(:linkable)
            expect(carousel.errors.full_messages).to include("must have linkable content.")
          end
        end
      end

      context "resource and custom_content are not present" do
        before(:each) { expect(carousel).to receive(:resource_present?).and_return(false) }

        context "external_link is present" do
          it "does not add error" do
            expect(carousel).to receive(:external_link_present?).and_return(true)
            carousel.send(:linkable)
            expect(carousel.errors.full_messages).not_to include("must have linkable content.")
          end
        end

        context "external_link is not present" do
          it "adds error" do
            expect(carousel).to receive(:external_link_present?).and_return(false)
            carousel.send(:linkable)
            expect(carousel.errors.full_messages).to include("must have linkable content.")
          end
        end
      end

      context "resource and external_link are not present" do
        context "custom_content is present" do
          let(:carousel) { Carousel.new(custom_content: "content") }

          it "does not add erorr" do
            carousel.send(:linkable)
            expect(carousel.errors.full_messages).not_to include("must have linkable content.")
          end
        end

        context "custom_content is not present" do
          let(:carousel) { Carousel.new() }

          it "does not add erorr" do
            carousel.send(:linkable)
            expect(carousel.errors.full_messages).to include("must have linkable content.")
          end
        end
      end
    end # linkable

    describe "external link format validation" do
      expect_it { to allow_value('http://foo.com', 'http://bar.com/baz').for(:external_link_url) }
      expect_it { not_to allow_value('asdfjkl').for(:external_link_url) }
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

  describe "resource_present?" do
    let(:subject) { carousel.resource_present? }

    context "resource_type and resource_id are present" do
      let(:carousel) { build(:carousel) }
      expect_it { to be_true }
    end

    context "only resource_type is present" do
      let(:carousel) { build(:carousel, resource_id: nil) }
      expect_it { to be_false }
    end

    context "only resource_id is present" do
      let(:carousel) { build(:carousel, resource_type: nil) }
      expect_it { to be_false }
    end

    context "both resource_type and resource_id are not present" do
      let(:carousel) { build(:carousel, resource_type: nil, resource_id: nil) }
      expect_it { to be_false }
    end
  end

  describe "external_link_present?" do
    let(:subject) { carousel.external_link_present? }

    context "external_link_url and external_link_text are present" do
      let(:carousel) { build(:carousel, external_link_url: "l", external_link_text: "t") }
      expect_it { to be_true }
    end

    context "only external_link_url is present" do
      let(:carousel) { build(:carousel, external_link_url: "l") }
      expect_it { to be_false }
    end

    context "only external_link_text is present" do
      let(:carousel) { build(:carousel, external_link_text: 't') }
      expect_it { to be_false }
    end

    context "both external_link_url and external_link_text are not present" do
      let(:carousel) { build(:carousel) }
      expect_it { to be_false }
    end
  end
end