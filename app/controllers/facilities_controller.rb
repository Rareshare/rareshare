class FacilitiesController < InternalController

  def edit
    @facility = Facility.find(params[:id])
    authorize! :update, @facility
  end

  def update
    @facility = Facility.find(params[:id])
    authorize! :update, @facility

    if @facility.update_attributes(facility_params)
      redirect_to tools_path, flash: { notify: "Tool saved."}
    else
      render 'facilities/edit'
    end
  end

  private

  def facility_params
    params.require(:facility).permit(
      :name,
      :address_attributes => address_attributes
    )
  end

end
