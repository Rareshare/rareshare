class RenameKeyWordsToKeywordsForTools < ActiveRecord::Migration
  def change
    rename_column :tools, :key_words, :keywords
  end
end
