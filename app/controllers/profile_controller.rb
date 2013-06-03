class ProfileController < InternalController

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to profile_path
    else
      render 'profile/edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :first_name,
      :last_name,
      :provider,
      :uid,
      :image_url,
      :linkedin_profile_url,
      :primary_phone,
      :secondary_phone,
      :bio,
      :title,
      :organization,
      :education,
      :qualifications,
      :avatar,
      :address_id,
      :address_attributes => [
        :address_line_1,
        :address_line_2,
        :city,
        :state,
        :postal_code
      ]
    )
  end

end
