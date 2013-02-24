class SearchQuery
  include ActiveAttr::Model

  attribute :loc, type: String
  attribute :on, type: Date
  attribute :q, type: String

  validates_presence_of :q

  def results
    self.on ||= Date.today
    bad_leases = Lease.select("tool_id, state").where(started_at: on).active.map(&:tool_id)
    @tools = Search.search_with_fuzzy_query_matching(q).where("searchable_id NOT IN (?)", bad_leases.any? ? bad_leases : -1).map(&:searchable)
  end
end
