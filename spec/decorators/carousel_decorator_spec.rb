require 'spec_helper'

describe CarouselDecorator do
  let(:decorator) { CarouselDecorator.new(carousel) }

  describe "link_url" do
    context "resource" do
      let(:carousel) { build(:carousel, resource_type: 'Tool', resource_id: 1) }

      it "returns the link for the resource" do
        expect(decorator.link_url).to eql(h.tool_path(1))
      end
    end

    context "external link" do
      let(:carousel) { Carousel.new(external_link: "http://google.com", external_link_title: "Google") }

      it "returns the external link" do
        expect(decorator.link_url).to eql(carousel.external_link)
      end
    end

    context "custom content" do
      let(:carousel) { Carousel.new(custom_content: "Good content") }

      it "returns '#carousel-modal'" do
        expect(decorator.link_url).to eql('#carousel-modal')
      end
    end
  end

  describe "link_text" do
    context "resource" do
      let(:carousel) { build(:carousel, resource_type: 'Tool', resource_id: tool.id) }
      let(:tool) { build(:tool) }

      it "returns the link for the resource" do
        tool.save(validate: false)
        expect(decorator.link_text).to eql(tool.display_name)
      end
    end

    context "external link" do
      let(:carousel) { Carousel.new(external_link: "http://google.com", external_link_title: "Google") }

      it "returns the external link" do
        expect(decorator.link_text).to eql(carousel.external_link_title)
      end
    end

    context "custom content" do
      let(:carousel) { Carousel.new(custom_content: "Good content") }

      it "returns '#carousel-modal'" do
        expect(decorator.link_text).to eql('About this image')
      end
    end
  end

  describe "link" do
    context "resource" do
      let(:carousel) { build(:carousel, resource_type: 'Tool', resource_id: tool.id) }
      let(:tool) { build(:tool) }

      it "returns the link for the resource" do
        tool.save(validate: false)
        expect(decorator.link).to eql(h.link_to(decorator.link_text, decorator.link_url))
      end
    end

    context "external link" do
      let(:carousel) { Carousel.new(external_link: "http://google.com", external_link_title: "Google") }

      it "returns the external link" do
        expect(decorator.link).to eql(h.link_to(decorator.link_text, decorator.link_url, target: "_blank"))
      end
    end

    context "custom content" do
      let(:carousel) { Carousel.new(custom_content: "Good content") }

      it "returns '#carousel-modal'" do
        expect(decorator.link).to eql(h.link_to(decorator.link_text, decorator.link_url, "data-toggle" => "modal"))
      end
    end
  end
end
