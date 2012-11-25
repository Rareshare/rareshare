require 'spec_helper'

describe Tool do
  context "when searched" do
    let(:manufacturer) { create(:manufacturer, name: "Venture Industries") }
    let(:model)        { create(:model, name: "Walking Eye", manufacturer: manufacturer) }
    let(:small_eye)         { create(:tool, model: model, resolution: "tiny") }
    let(:large_eye)         { create(:tool, model: model, resolution: "huge") }
    before             { small_eye; large_eye }

    specify { Tool.search("").should be_empty }
    specify { Tool.search("Don't know").should be_empty }
    specify { Tool.search("Venture").should =~ [ small_eye, large_eye ] }
    specify { Tool.search("Venture tiny").should =~ [ small_eye ] }
    specify { Tool.search("Venture huge").should =~ [ large_eye ] }
  end
end
