class SearchesController < ApplicationController
  add_breadcrumb "Search", '/search'

  def show
    date = Date.strptime(params[:on], "%d %B, %Y")
    bad_leases = Lease.select("DISTINCT tool_id").where(started_at: date).map(&:id)

    @tools = Search.search(params[:q]).where("searchable_id NOT IN (?)", bad_leases.any? ? bad_leases : -1).map(&:searchable)
  end
end