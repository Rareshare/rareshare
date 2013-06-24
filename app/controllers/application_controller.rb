class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :logged_in?
  layout "external"

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to profile_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def after_sign_in_path_for(user)
    return_to = session[:user_return_to]
    if return_to && !return_to.match(user_omniauth_callback_path(:linkedin))
      return_to
    else
      profile_path
    end
  end

  def authenticate_admin_user!
    authenticate_user! && current_user.admin?
  end

  private

  def address_attributes
    [
      :address_line_1,
      :address_line_2,
      :city,
      :state,
      :postal_code,
      :country
    ]
  end
end
