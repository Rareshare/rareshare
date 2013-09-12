class UsersController < InternalController

  def show
    @user = User.find(params[:id])
  end

  def skills
    render json: Skill.where("name LIKE ?", params[:q]).order(:name).limit(10)
  end

end
