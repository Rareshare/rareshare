class UserMessage < ActiveRecord::Base

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  scope :unread, -> { where(acknowledged: false) }
  belongs_to :messageable, polymorphic: true
  after_create :make_self_originator_if_first

  def first?
    self.originating_message_id == self.id
  end

  def message_chain
    UserMessage.where(originating_message_id: self.originating_message_id)
  end

  def append(attrs={})
    self.class.create attrs.merge(originating_message_id: self.originating_message_id)
  end

  def reply!(sender, body)
    sender_id = sender.respond_to?(:id) ? sender.id : sender
    receiver_id = sender_id == self.sender_id ? self.receiver_id : self.sender_id
    UserMessage.new(body: body).tap do |um|
      um.sender_id = sender_id
      um.receiver_id = receiver_id
      um.messageable_type = self.messageable_type
      um.messageable_id = self.messageable_id
      um.originating_message_id = self.originating_message_id || self.id
      um.save!
    end
  end

  def sender_name
    self.sender.present? ? sender.display_name : "Deleted User"
  end

  private

  def make_self_originator_if_first
    self.originating_message_id = self.id if self.originating_message_id.blank?
    save!
  end

end
