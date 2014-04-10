class RenameExternalLinkFieldsForCarousels < ActiveRecord::Migration
  def change
    rename_column :carousels, :external_link_title, :external_link_text
    rename_column :carousels, :external_link, :external_link_url
  end
end
