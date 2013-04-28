class UsersController < InternalController

  def show
    @user = User.find(params[:id])
  end

end
