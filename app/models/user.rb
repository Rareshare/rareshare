class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_many :leases, foreign_key: :lessee_id
  has_many :tools, foreign_key: :owner_id
  has_many :received_messages, foreign_key: :receiver_id, class_name: "UserMessage"
  has_many :sent_messages, foreign_key: :sender_id, class_name: "UserMessage"
  has_and_belongs_to_many :roles
  has_one :address, as: :addressable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :provider, :uid, :image_url, :linkedin_profile_url, :primary_phone, :secondary_phone, :bio, :title, :organization, :education, :qualifications
  accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank
  attr_accessible :address_attributes
  
  validates :first_name, :last_name, :email, presence: true

  def unread_message_count
    received_messages.unread.count
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
    leases.build.tap do |l|
      l.lessor_id    = params[:lessor_id]
      l.tool_id      = params[:tool_id]
      l.started_at   = params[:started_at]
      l.ended_at     = params[:ended_at]
      l.tos_accepted = params[:tos_accepted]
      l.description  = params[:description]

      l.save
    end
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
        image_url: auth.info.image,
        linkedin_profile_url: auth.info.urls.public_profile
      )
    end

    user.save
    user
  end
end
