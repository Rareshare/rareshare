class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_many :tools, foreign_key: :owner_id
  has_many :received_messages, foreign_key: :receiver_id, class_name: "UserMessage"
  has_many :sent_messages, foreign_key: :sender_id, class_name: "UserMessage"
  # has_and_belongs_to_many :roles
  has_one :address, as: :addressable

  has_many :requested_bookings, class_name: "Booking", foreign_key: :renter_id
  has_many :owned_bookings, through: :tools, source: :bookings
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  validates :first_name, :last_name, :email, presence: true

  mount_uploader :avatar, ImageUploader

  def unread_message_count
    received_messages.unread.count
  end

  def all_messages
    UserMessage.where("receiver_id = ? OR sender_id = ?", self.id, self.id)
  end

  def acknowledge_message!(message)
    received_messages.unread.where(originating_message_id: message.originating_message_id).update_all(acknowledged: true)
  end

  def can_read?(message)
    message.sender == self || message.receiver == self
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def request_reservation!(params={})
    tool                = Tool.find(params[:tool_id]) # or raise RecordNotFound
    deadline            = Date.parse(params[:deadline])
    params[:price]      = tool.price_for(params[:deadline])
    params[:updated_by] = self

    requested_bookings.create params
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
    ( owned_bookings.recent + requested_bookings.recent ).sort_by(&:updated_at).reverse
  end

  def self.administrative
    scope = User.where(
      first_name: "RareShare",
      last_name:  "Support",
      email:      "support@rare-share.com"
    )

    scope.first || scope.create
  end

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    if user = User.where(email: auth.info.email).first
      user.link_profile(auth) unless user.provider_linked?
    elsif user = User.where(:provider => auth.provider, :uid => auth.uid).first
      user.email = auth.info.email # We have the user, but they've changed addresses in LinkedIn.
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
end
