class SearchesController < ApplicationController
  add_breadcrumb "Search", '/search'

  def show
    @query = SearchQuery.new(params)
    @results = @query.results
  end
end