class SearchesController < InternalController
  helper :tools
  def show
    @query = SearchQuery.new(params)
    @results = @query.results
  end
end
