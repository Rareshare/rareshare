class AddKeyWordsToTools < ActiveRecord::Migration
  def change
    add_column :tools, :key_words, :string, array: true, default: []
  end
end
