class SearchQuery
  include ActiveAttr::Model

  attribute :loc, type: String
  attribute :on, type: Date
  attribute :q, type: String

  validates_presence_of :q

  def results
    bad_leases = Lease.select("tool_id").where(started_at: on).active.map(&:tool_id)
    @tools = Search.search(q).where("searchable_id NOT IN (?)", bad_leases.any? ? bad_leases : -1).map(&:searchable)
  end
end
