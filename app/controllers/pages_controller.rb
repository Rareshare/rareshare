class PagesController < ApplicationController

  def show
    @page = Page.where("id = ? OR slug = ?", params[:page], params[:page]).first
    not_found if @page.nil?
  end

end
