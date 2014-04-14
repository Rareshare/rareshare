class ProfileController < InternalController
  skip_before_filter :tos_accepted?, only: [:welcome, :update]

  def show
  end

  def edit
  end

  def welcome
    render 'welcome', layout: 'external'
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
      :tos_accepted,
      :skills_tags,
      :address_attributes => address_attributes
    ).tap do |params|
      if params[:skills_tags].present?
        params[:skills_tags] = params[:skills_tags].split(", ")
      end
    end
  end

end
