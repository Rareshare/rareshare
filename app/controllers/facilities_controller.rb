class FacilitiesController < InternalController
  before_action :find_facility, only: [:edit, :update, :destroy]

  def index
    @facilities = current_user.facilities
  end

  def new
    @facility = current_user.facilities.build
  end

  def create
    @facility = Facility.new(facility_params)

    if @facility.save
      flash[:success] = "Successfully created facility"
    else
      flash[:error] = @facility.errors.full_messages
    end

    redirect_to facilities_path
  end

  def edit
    authorize! :manage, @facility
  end

  def update
    authorize! :manage, @facility

    if @facility.update_attributes(facility_params)
      redirect_to facilities_path, flash: { notify: "Successfully updated the facility."}
    else
      flash[:error] = @facility.errors.full_messages
      render 'facilities/edit'
    end
  end

  def destroy
    authorize! :manage, @facility

    if @facility.tools.empty?
      @facility.destroy
      flash[:success] = "Successfully deleted the facility."
    else
      flash[:error] = "You cannot delete this facility, because some tools are registered to this facility."
    end

    redirect_to facilities_path
  end
  private

  def find_facility
    @facility = Facility.find(params[:id])
  end

  def facility_params
    params.require(:facility).permit(
      :user_id,
      :name,
      :description,
      :department,
      :address_attributes => address_attributes | [:id]
    )
  end

end
