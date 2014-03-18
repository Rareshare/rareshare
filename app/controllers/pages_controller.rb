class PagesController < ApplicationController

  def show
    @page = Page.find(params[:page]) || Page.where(slug: params[:page]).first
    not_found if @page.nil?
  end

end
