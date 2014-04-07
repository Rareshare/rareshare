class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :logged_in?
  layout "external"
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :redirect_to_login, unless: :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to profile_path
  end

  def not_found!
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

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :email, :first_name, :last_name, :password, :password_confirmation
    end
  end

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

  def redirect_to_login
    accepted_paths = [root_path, new_user_session_path,
                      new_user_registration_path, page_path('learn-more'),
                      page_path('get-help'), page_path('terms-conditions'),
                      page_path('privacy-policy'), page_path('cookies')]

    unless accepted_paths.include?(request.path)
      flash[:notice] = "Please sign up."
      redirect_to new_user_registration_path
    end
  end

  def back_or_home
    default, back, return_to = profile_path, request.env["HTTP_REFERER"], session[:user_return_to]

    if back.present? && return_to != request.fullpath
      back
    else
      default
    end
  end
end
