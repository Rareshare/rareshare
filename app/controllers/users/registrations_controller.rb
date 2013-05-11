class Users::RegistrationsController < Devise::RegistrationsController

  private

  def after_inactive_sign_up_path_for(resource)
    new_user_registration_path
  end

  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
