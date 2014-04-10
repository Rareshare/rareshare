class AddExternalLinkAndCustomContentToCarousels < ActiveRecord::Migration
  def change
    add_column :carousels, :external_link, :string
    add_column :carousels, :custom_content, :text
  end
end
