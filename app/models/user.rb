class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_and_belongs_to_many :roles

  has_many :leases, foreign_key: :lessee_id
  has_many :tools, foreign_key: :owner_id
  has_many :received_messages, foreign_key: :receiver_id, class_name: "UserMessage"
  has_many :sent_messages, foreign_key: :sender_id, class_name: "UserMessage"

  def unread_message_count
    received_messages.unread.count
  end

  def reserve(params={})
    leases.build.tap do |l|
      l.lessor_id    = params[:lessor_id]
      l.tool_id      = params[:tool_id]
      l.started_at   = params[:started_at]
      l.ended_at     = params[:ended_at]
      l.tos_accepted = params[:tos_accepted]
    end
  end
end
