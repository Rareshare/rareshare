class UserMessage < ActiveRecord::Base

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :messageable, polymorphic: true
  has_many :notifications, as: :notifiable

  after_create :make_self_originator_if_first
  after_create :notify

  def first?
    self.originating_message_id == self.id
  end

  def message_chain
    UserMessage.where(originating_message_id: self.originating_message_id).order(:created_at)
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

  private
  def notify
    if messageable.is_a?(Tool)
      self.notifications.create(
        user: receiver,
        notifiable: self,
        properties: {
          key: "tools.question.asked",
          question: body.truncate(100),
          tool_id: messageable_id,
          tool_name: messageable.display_name
        }
      )
    end
  end
end
