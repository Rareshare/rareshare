class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:user_return_to] || dashboard_path
  end

  def logged_in?
    !!current_user
  end
end
