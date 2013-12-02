class AddUserQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.integer :questionable_id
      t.integer :questionable_type
      t.string :topic
      t.text :body
      t.timestamps
    end

    create_table :question_responses do |t|
      t.integer :question_id
      t.integer :user_id
      t.text :body
      t.timestamps
    end
  end
end
