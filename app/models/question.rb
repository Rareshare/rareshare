class Question < ActiveRecord::Base
  validates :body, :user_id, :topic, presence: true

  belongs_to :user
  belongs_to :questionable, polymorphic: true
  has_many :question_responses

  module Topics
    TRANSIT = "transit"
    SAFETY  = "safety"
    PRICING = "pricing"
    IP      = "ip"
    OTHER   = "other"

    ALL = [ TRANSIT, SAFETY, PRICING, IP, OTHER ]
    COLLECTION = ALL.map {|k| [ I18n.t("questions.topic.#{k}"), k ]}
  end

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
  end

  def reply_with(reply_params)
    latest = self.question_responses.order("created_at DESC").limit(1).first
    self.question_responses.create(reply_params).tap do |reply|
      can_notify = self.questionable.is_a?(Booking)
      worth_notifying_about = ( latest.nil? || latest.user_id != reply.user_id )

      if reply.valid? && can_notify && worth_notifying_about
        self.questionable.notifications.create(
          user: latest.try(:user) || self.user,
          properties: {
            key: "questions.notify.replied",
            tool_name: self.questionable.is_a?(Tool) ? self.questionable.display_name : self.questionable.tool.display_name,
            reply: reply.body.truncate(100)
          }
        )
      end
    end
  end

  def as_json(opts={})
    super(opts).merge(
      user: self.user.as_json,
      body: self.class.markdown.render(self.body),
      created_at: self.created_at.to_s(:short),
      updated_at: self.updated_at.to_s(:short),
      question_responses: self.question_responses,
      topic_translated: I18n.t("questions.topic.#{self.topic}"),
      question_reply_path: self.new_record? ? nil : "/bookings/#{self.questionable_id}/questions/#{self.id}/reply"
    )
  end
end
