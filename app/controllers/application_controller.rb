class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :logged_in?
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def after_sign_in_path_for(resource_or_scope)
    return_to = session[:user_return_to]
    if return_to && !return_to.match(user_omniauth_callback_path(:linkedin))
      return_to
    else
      dashboard_path
    end
  end
end
