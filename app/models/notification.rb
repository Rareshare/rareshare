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
    I18n.t(key, properties_with_indifferent_access).html_safe
  end

  def tool_name
    properties_with_indifferent_access['tool_name']
  end

  def key
    properties_with_indifferent_access['key']
  end

  protected

  def send_email
    Rails.logger.debug %|sending email "#{key}" for notification #{id}|
    case key
    when 'bookings.notify.asked'
      NotificationMailer.delay.question_asked id
    when 'bookings.notify.cancelled'
      NotificationMailer.delay.booking_cancelled id
    when 'bookings.notify.confirmed'
      NotificationMailer.delay.booking_confirmed id
    when 'bookings.notify.pending'
      NotificationMailer.delay.booking_request id
    when 'bookings.notify.finalized_owner', 'bookings.notify.finalized_renter'
      NotificationMailer.delay.booking_finalized id
    when 'bookings.notify.processing'
      NotificationMailer.delay.booking_processing id
    when 'bookings.notify.completed'
      NotificationMailer.delay.booking_completed id
    when 'tools.question.asked'
      NotificationMailer.delay.tool_question_asked id
    when 'tools.question.replied'
      NotificationMailer.delay.tool_question_replied id
    else
      NotificationMailer.delay.email id
    end
  end

  def properties_with_indifferent_access
    @properties_with_indifferent_access ||= properties.with_indifferent_access
  end
end
