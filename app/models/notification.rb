class Notification < ActiveRecord::Base
  belongs_to :notifiable, polymorphic: true
  belongs_to :user
  validates_presence_of :user
  default_scope { order("notifications.created_at DESC") }
  after_create :send_email

  scope :questions, -> { where("properties -> :key LIKE :value", key: 'key', value: "%asked%") }
  scope :answers, -> { where("properties -> :key LIKE :value", key: 'key', value: "%replied%") }

  def self.unseen
    where(seen_at: nil)
  end

  def self.recent
    limit(10).order("created_at DESC")
  end

  def seen!
    touch(:seen_at)
  end

  def seen?
    !self.seen_at.blank?
  end

  def unseen?; !seen?; end

  def body
    I18n.t(self.properties['key'], self.properties.with_indifferent_access).html_safe
  end

  protected

  def send_email
    NotificationMailer.delay.email(self.id)
  end
end
