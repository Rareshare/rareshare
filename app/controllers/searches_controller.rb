class SearchesController < ApplicationController
  helper :tools
  after_filter :track_search_results, only: :show

  layout :layout_for_current_user

  def show
    @query = SearchQuery.new(params)
    @results = @query.results
  end

  private

  def track_search_results
    ExecutedSearch.create(
      user: current_user,
      results_count: @results.total_count,
      search_params: params.slice(:q, :by, :loc)
    )
  end

  def layout_for_current_user
    signed_in? ? "internal" : "external"
  end
end
