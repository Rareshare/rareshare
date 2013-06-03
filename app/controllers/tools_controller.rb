class ToolsController < InternalController

  def index
    @tools = current_user.tools.all
  end

  def show
    @tool = Tool.find(params[:id])
    authorize! :read, @tool
    add_breadcrumb @tool.display_name, tool_path(@tool)
  end

  def new
    @tool = current_user.tools.build(params[:tool] || {})
    authorize! :create, @tool
    add_breadcrumb "New " + @tool.display_name, new_tool_path
  end

  def edit
    @tool = Tool.find(params[:id])
    authorize! :update, @tool
    add_breadcrumb "Edit " + @tool.display_name, edit_tool_path(@tool)
  end

  def update
    @tool = Tool.find(params[:id])
    authorize! :update, @tool

    if @tool.update_attributes(tool_params)
      redirect_to tool_path(@tool), flash: { notify: "Tool saved."}
    else
      render 'tools/edit'
    end
  end

  def create
    @tool = current_user.tools.create tool_params
    authorize! :create, @tool

    if @tool.valid?
      redirect_to tool_images_path(@tool), flash: { notify: "Tool created! Why not add some images?" }
    else
      render 'tools/new'
    end
  end

  def destroy
    tool = current_user.tools.find(params[:id])
    authorize! :destroy, @tool

    if tool.present?
      tool.destroy
      redirect_to :back, flash: { notify: "Tool successfully deleted." }
    else
      redirect_to :back, flash: { notify: "No tool with that ID found." }
    end
  end

  private

  def tool_params
    params.require(:tool).permit(
      :manufacturer_id,
      :year_manufactured,
      :serial_number,
      :model_id,
      :description,
      :resolution,
      :resolution_unit_id,
      :sample_size_min,
      :sample_size_max,
      :sample_size_unit_id,
      :base_price,
      :base_lead_time,
      :can_expedite,
      :expedited_price,
      :expedited_lead_time,
      :tool_category_name,
      :manufacturer_name,
      :model_name,
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
