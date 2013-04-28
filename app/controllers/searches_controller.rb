class SearchesController < ApplicationController
  helper :tools

  layout :layout_for_current_user

  def show
    @query = SearchQuery.new(params)
    @results = @query.results
  end

  private

  def layout_for_current_user
    signed_in? ? "internal" : "external"
  end
end
