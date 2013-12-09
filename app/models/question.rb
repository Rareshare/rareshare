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

  def as_json(opts={})
    super(opts).merge(
      user: self.user.as_json,
      body: self.class.markdown.render(self.body)
    )
  end
end
