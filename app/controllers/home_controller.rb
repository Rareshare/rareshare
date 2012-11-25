class HomeController < ApplicationController
  def index
    redirect_to dashboard_url if logged_in?
  end
end
