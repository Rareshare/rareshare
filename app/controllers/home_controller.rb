class HomeController < ApplicationController
  def index
    redirect_to profile_url if user_signed_in?
  end
end
