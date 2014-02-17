class ChangeQuestionableTypeToString < ActiveRecord::Migration
  def change
    remove_column :questions, :questionable_type, :int
    add_column :questions, :questionable_type, :string
    Question.update_all questionable_type: "Booking"
  end
end
