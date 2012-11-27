class SearchesController < ApplicationController
  def show
    @query = SearchQuery.new(params)
    @results = @query.results
  end
end
