class AddPdfToPages < ActiveRecord::Migration
  def change
    add_column :pages, :pdf, :text
  end
end
