class SearchQuery
  include ActiveAttr::Model

  attribute :loc, type: String
  attribute :by, type: Date
  attribute :q, type: String
  attribute :page, type: Integer, default: 1
  attribute :per_page, type: Integer, default: 10

  validates_presence_of :q

  def self.default_date
    2.weeks.from_now
  end

  def default_date; self.class.default_date; end

  def results
    if valid?
      self.by ||= default_date

      scope = Tool
      scope = scope.near(self.loc, 25) if self.loc.present?
      scope = scope.bookable_by(self.by)
      scope = scope.advanced_search "'#{self.q}':*"
      scope = scope.paginate page: self.page, per_page: self.per_page
      scope
    else
      []
    end
  end
end
