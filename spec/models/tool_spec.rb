require 'spec_helper'

describe Tool do
  Given(:tool) { create :tool }

  # TODO These can probably go into their own NameDelegator spec.
  context "nested models" do
    def id_of(model_class, name)
      model_class.where(name: name).pluck(:id).first
    end

    context "when setting model" do
      When { tool.update_attributes model_name: "Some model" }
      Then { expect(tool.model.id).to eq id_of(Model, "Some model") }
    end

    context "when setting manufacturer" do
      When { tool.update_attributes(manufacturer_name: "Some manufacturer") }
      Then { expect(tool.manufacturer.id).to eq id_of(Manufacturer, "Some manufacturer") }
    end

    context "when setting tool category" do
      When { tool.update_attributes(tool_category_name: "Some category") }
      Then { expect(tool.tool_category.id).to eq id_of(ToolCategory, "Some category") }
    end
  end

  context "when generating a name for display" do
    When { tool.manufacturer_name = "RareShare" }
    When { tool.model_name = "Killbot 3000" }
    Then { expect(tool.display_name).to eq "RareShare Killbot 3000" }
  end
end
