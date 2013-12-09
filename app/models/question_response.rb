class QuestionResponse < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true

  def as_json(opts={})
    super(opts).merge(user: { display_name: self.user.display_name, user_path: "/users/#{self.user_id}" })
  end
end
