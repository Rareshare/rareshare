class SearchesController < ApplicationController
  def show
    @tools = Tool.search(params[:q])
  end
end