class PagesController < ApplicationController
  layout :external

  def show
    @page = Page.find(params[:page])
    not_found if @page.nil?
  end

end
