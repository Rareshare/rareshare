class SearchQuery
  include ActiveAttr::Model

  attribute :loc, type: String
  attribute :by, type: Date
  attribute :q, type: String

  validates_presence_of :q

  def self.default_date
    1.week.from_now
  end

  def default_date; self.class.default_date; end

  def results
    self.by ||= default_date
    @tools = Tool.bookable_by(self.by).search "'#{self.q}':*"
  end
end
