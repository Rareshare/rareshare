class HomeController < ApplicationController
  def index
    redirect_to dashboard_url if user_signed_in?
  end
end
