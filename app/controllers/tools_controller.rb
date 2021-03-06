class ToolsController < InternalController

  def index
    @tools = current_user.tools.all
  end

  def show
    @tool    = Tool.find(params[:id])
    @booking = Booking.default(current_user, @tool, params.permit(:date))
    authorize! :read, @tool
    add_breadcrumb @tool.display_name, tool_path(@tool)
  end

  def new
    @tool = current_user.tools.build(params[:tool] || { currency: "GBP" })
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

    Tool.transaction do
      @tool.assign_attributes(tool_params)

      if params[:commit] == t('tools.action_type.update_sandbox')
        @tool.sandbox_listing
        redirect_to @tool, flash: { notify: "Tool updated."}
      else
        if current_user.stripe_access_token
          if @tool.go_live_with_listing
            redirect_to @tool, flash: { notify: "Tool updated."}
          else
            render 'tools/edit'
          end
        else
          @tool.sandbox_listing
          flash[:error] = "You need to connect with Stripe in order to go live with your tools."
          redirect_to edit_tool_path(@tool), flash: { notify: "Tool created."}
        end
      end
    end
  end

  def create
    @tool = current_user.tools.new tool_params

    authorize! :create, @tool

    if params[:commit] == t('tools.action_type.create_sandbox')
      @tool.sandbox_listing
      redirect_to @tool, flash: { notify: "Tool created."}
    else
      if current_user.stripe_access_token
        if @tool.go_live_with_listing
          redirect_to @tool, flash: { notify: "Tool created." }
        else
          render 'tools/new'
        end
      else
        @tool.sandbox_listing
        flash[:error] = "You need to connect with Stripe in order to go live with your tools."
        redirect_to edit_tool_path(@tool), flash: { notify: "Tool created."}
      end
    end
  end

  def destroy
    tool = current_user.tools.find(params[:id])
    authorize! :destroy, tool

    if tool.present?
      tool.destroy
      redirect_to :back, flash: { notify: "Tool successfully deleted." }
    else
      redirect_to :back, flash: { notify: "No tool with that ID found." }
    end
  end

  def pricing
    tool    = Tool.find(params[:id])
    date    = params[:date]
    samples = params[:samples]
    subtype = params[:subtype]

    price = tool.tool_price_for(subtype)

    render json: {
      pricing: {
        setup_price:   price.setup_price,
        base_price:    price.base_price_for(date, samples),
        can_expedite:  price.can_expedite?,
        must_expedite: price.must_expedite?(date),
        total_price:   price.price_for(date, samples)
      }
    }
  end

  private

  def tool_params
    params.require(:tool).permit(
      :manufacturer_id,
      :year_manufactured,
      :serial_number,
      :model_id,
      :keywords,
      :description,
      :sample_size_min,
      :sample_size_max,
      :sample_size_unit_id,
      :currency,
      :samples_per_run,
      :base_price,
      :base_lead_time,
      :can_expedite,
      :expedited_price,
      :expedited_lead_time,
      :price_type,
      :bulk_runs,
      :tool_category_name,
      :manufacturer_name,
      :model_name,
      :address_id,
      :facility_id,
      :sample_delivery_address_id,
      :access_type,
      :access_type_notes,
      :calibrated,
      :last_calibrated_at,
      :condition,
      :condition_notes,
      :terms_document_id,
      :facility_attributes => [
        :name, :id,
        { :address_attributes => address_attributes }
      ],
      :sample_delivery_address_attributes => [
        :name, :id,
        { :address_attributes => address_attributes }
      ],
      :images_attributes => [
        :id,
        :file_id,
        :position,
        :category,
        :_destroy
      ],
      :documents_attributes => [
        :id,
        :file_id,
        :position,
        :category,
        :_destroy
      ],
      :per_sample_tool_prices_attributes => [
        :id,
        :subtype,
        :base_amount,
        :setup_amount,
        :lead_time_days,
        :expedite_time_days,
        :_destroy
      ],
      :per_time_tool_price_attributes => [
        :time_unit,
        :amount_per_time_unit,
        :setup_amount,
        :expedite_time_days,
        :lead_time_days,
        :id
      ]
    ).tap do |params|
      if params[:facility_attributes].present?
        params[:facility_attributes][:user_id] = current_user.id
      end

      if params[:sample_delivery_address_attributes].present?
        params[:sample_delivery_address_attributes][:user_id] = current_user.id
      end

      if params[:keywords].present?
        params[:keywords] = params[:keywords].split(", ")
      end
    end
  end

end
