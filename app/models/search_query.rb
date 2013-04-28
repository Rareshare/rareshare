class SearchQuery
  include ActiveAttr::Model

  attribute :loc, type: String
  attribute :by, type: Date
  attribute :q, type: String
  attribute :page, type: Integer, default: 1
  attribute :per_page, type: Integer, default: 10

  def self.default_date
    2.weeks.from_now.to_date
  end

  def default_date; self.class.default_date; end

  def results
    self.by ||= default_date

    scope = Tool
    scope = scope.near(self.loc, 25) if self.loc.present?
    scope = scope.bookable_by(self.by)
    scope = scope.advanced_search "'#{self.q}':*" if self.q.present?
    scope = scope.page(self.page).per(self.per_page)
    scope
  end
end
