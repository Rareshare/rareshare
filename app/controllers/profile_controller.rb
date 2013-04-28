class ProfileController < InternalController

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to profile_path
    else
      render 'profile/edit'
    end
  end
end
