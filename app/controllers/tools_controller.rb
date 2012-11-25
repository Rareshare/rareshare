class ToolsController < ApplicationController
  before_filter :authenticate_user!

  add_breadcrumb 'Tools', ''

  def show
    @tool = Tool.find(params[:id])
    add_breadcrumb @tool.display_name, tool_path(@tool)
  end

  def new
    @tool = current_user.tools.build
  end

  def create
    @tool = current_user.tools.build.tap do |t|
      t.model_id = params[:tool][:model_id]
      t.resolution = params[:tool][:resolution]
      t.sample_size = params[:tool][:sample_size]
      t.price_per_hour = (Float(params[:tool][:price_per_hour]) * 100).to_i
      t.technician_required = params[:tool][:technician_required]
    end

    if @tool.valid?
      @tool.save!
      redirect_to dashboard_path(anchor: "tools", flash: { notify: "Tool successfully created!"})
    else
      render 'tools/new'
    end
  end

  def destroy
    tool = current_user.tools.find(params[:id])

    if tool.present?
      tool.destroy
      redirect_to :back, flash: { notify: "Tool successfully deleted." }
    else
      redirect_to :back, flash: { notify: "No tool with that ID found." }
    end
  end

end