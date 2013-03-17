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
    bad_leases = Lease.select("tool_id, state").where(started_at: by).active.map(&:tool_id)
    @tools = Search.where("searchable_id NOT IN (?)", bad_leases.any? ? bad_leases : -1).search_with_fuzzy_query_matching(q).map(&:searchable)
  end
end
