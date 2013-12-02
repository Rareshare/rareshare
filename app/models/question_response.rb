class QuestionResponse < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true
end
