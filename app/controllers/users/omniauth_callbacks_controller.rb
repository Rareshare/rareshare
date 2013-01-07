class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    @user = User.find_for_linkedin_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted? && @user.valid?
      logger.info "(linkedin) debug: we are persisted, redirecting to #{after_sign_in_path_for(@user)}"
      set_flash_message(:notice, :success, :kind => "LinkedIn") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
