class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, :async

  has_many :tools, foreign_key: :owner_id, dependent: :destroy
  has_many :received_messages, foreign_key: :receiver_id, class_name: "UserMessage", dependent: :destroy
  has_many :sent_messages, foreign_key: :sender_id, class_name: "UserMessage", dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_many :facilities, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :terms_documents, dependent: :destroy

  has_many :requested_bookings, class_name: "Booking", foreign_key: :renter_id, dependent: :destroy
  has_many :owned_bookings, through: :tools, source: :bookings

  has_and_belongs_to_many :skills

  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  validates :first_name, :last_name, :email, presence: true

  before_save :notify_approval, if: :admin_approved_changed?

  scope :admin, -> { where(admin: true) }

  mount_uploader :avatar, ImageUploader

  def new_notifications
    self.notifications.unseen
  end

  def all_messages
    UserMessage.where("receiver_id = ? OR sender_id = ?", self.id, self.id)
  end

  def acknowledge_message!(message)
    received_messages.unread.where(
      originating_message_id: message.originating_message_id
    ).update_all(acknowledged: true)
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def link_profile(auth)
    self.provider = auth.provider
    self.uid = auth.uid
    self.linkedin_profile_url = auth.info.urls.public_profile
    self.image_url ||= auth.info.image
  end

  def provider_linked?
    self.provider.present?
  end

  def all_recent_bookings
    ( owned_bookings.non_draft.recent + requested_bookings.recent ).sort_by(&:updated_at).reverse
  end

  def skills_tags=(skills)
    skills = skills.split(",") if skills.is_a? String
    skills = skills.compact

    existing_skills = Skill.where(name: skills)
    new_skills = skills - existing_skills.map(&:name)
    new_skills = new_skills.map {|s| Skill.create(name: s)}

    self.skills = new_skills + existing_skills
  end

  def skills_tags
    self.skills.map &:name
  end

  SUPPORT_EMAIL = "support@rare-share.com"

  def self.administrative
    scope = self.where(email: SUPPORT_EMAIL)

    @administrative ||= scope.first || scope.create(
      first_name: "RareShare",
      last_name:  "Support",
      password:   SecureRandom.hex(16)
    )
  end

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    if user = User.where(email: auth.info.email).first
      user.link_profile(auth) unless user.provider_linked?
    elsif user = User.where(:provider => auth.provider, :uid => auth.uid).first
      # We have the user, but they've changed addresses in LinkedIn.
      user.skip_reconfirmation!
      user.email = auth.info.email
    else
      user = User.new(
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0,20],
        avatar: { tempfile: open(auth.info.image), filename: "#{auth.uid}.png" },
        linkedin_profile_url: auth.info.urls.public_profile
      )
    end

    user.save
    user
  end

  def as_json(opts={})
    super opts.merge(methods: %w{display_name})
  end

  private

  def notify_approval
    if admin_approved?
      UserMailer.delay.approval_email(id)
    else
      UserMailer.delay.suspension_email(id)
    end
  end
end
