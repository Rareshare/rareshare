class Notification < ActiveRecord::Base
  belongs_to :notifiable, polymorphic: true
  belongs_to :user
  validates_presence_of :user

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
end
