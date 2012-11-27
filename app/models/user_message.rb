class UserMessage < ActiveRecord::Base

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  default_scope order("created_at ASC")

  scope :unread, where(acknowledged: false)

  attr_accessible :body
  belongs_to :messageable, polymorphic: true
  after_create :make_self_originator_if_first

  def first?
    self.originating_message_id == self.id
  end

  def message_chain
    UserMessage.where(originating_message_id: self.originating_message_id)
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

  private

  def make_self_originator_if_first
    self.originating_message_id = self.id if self.originating_message_id.blank?
    save!
  end

end
