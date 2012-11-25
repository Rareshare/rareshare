class UsersController < ApplicationController
  before_filter :authenticate_user!
  add_breadcrumb "Dashboard", '/dashboard'

  def dashboard
  end

end
