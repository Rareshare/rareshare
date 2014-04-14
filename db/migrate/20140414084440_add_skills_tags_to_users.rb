class AddSkillsTagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :skills_tags, :string, array: true, default: []
  end
end
