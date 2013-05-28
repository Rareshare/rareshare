require 'spec_helper'

describe SearchQuery do
  let(:manufacturer) { create(:manufacturer, name: "Venture Industries") }
  let(:model)        { create(:model, name: "Walking Eye", manufacturer: manufacturer) }
  let(:small_eye)    { create(:tool, model: model, description: "tiny") }
  let(:large_eye)    { create(:tool, model: model, description: "huge") }
  before             { small_eye; large_eye }

  let(:q) { nil }
  subject { SearchQuery.new(q: q) }

  context 'with empty query' do
    let(:q) { "" }
    its(:results) { should =~ [ small_eye, large_eye ] }
  end

  context 'with nothing found' do
    let(:q) { "General Electric Toaster" }
    its(:results) { should be_empty }
  end

  context 'with many found' do
    let(:q) { "Venture" }
    its(:results) { should =~ [ small_eye, large_eye ] }
  end

  context 'with more detail' do
    let(:q) { "Venture tiny" }
    its(:results) { should =~ [ small_eye ] }
  end
end
