class AddExternalLinkTitleToCarousels < ActiveRecord::Migration
  def change
    add_column :carousels, :external_link_title, :string
  end
end
