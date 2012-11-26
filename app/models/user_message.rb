class UserMessage < ActiveRecord::Base

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  scope :unread, where(acknowledged: false)

  attr_accessible :sender_id, :sender, :receiver_id, :receiver, :body, :messageable_id, :messageable_type

  belongs_to :messageable, polymorphic: true

  def first?
    self.prev.blank?
  end

  def last?
    self.next.blank?
  end

  def prev
    UserMessage.where(id: self.reply_to_id).first
  end

  def next
    UserMessage.where(reply_to_id: self.id).first
  end

end