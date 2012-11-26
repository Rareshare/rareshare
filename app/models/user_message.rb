class UserMessage < ActiveRecord::Base

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  default_scope order("created_at ASC")

  scope :unread, where(acknowledged: false)

  attr_accessible :body
  belongs_to :messageable, polymorphic: true

  def first?
    self.originating_message_id.blank?
  end

  def message_chain
    UserMessage.where("id = ? OR originating_message_id = ?", self.id, self.id)
  end

  def acknowledge!
    unless self.acknowledged?
      self.acknowledged = true
      self.save!
    end
    self
  end

  def reply!(body)
    UserMessage.new(body: body).tap do |um|
      um.sender_id = self.receiver_id
      um.receiver_id = self.sender_id
      um.messageable_type = self.messageable_type
      um.messageable_id = self.messageable_id
      um.originating_message_id = self.originating_message_id || self.id
      um.save!
    end
  end

end