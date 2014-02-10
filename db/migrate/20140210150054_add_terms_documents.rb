class AddTermsDocuments < ActiveRecord::Migration
  def change
    create_table :terms_documents do |t|
      t.string :pdf
      t.string :title
      t.integer :user_id
      t.timestamps
    end

    add_index :terms_documents, :user_id
    add_column :tools, :terms_document_id, :integer
  end
end
