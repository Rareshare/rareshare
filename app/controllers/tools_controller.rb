class ToolsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @tool = Tool.find(params[:id])
    add_breadcrumb @tool.display_name, tool_path(@tool)
  end

  def new
    @tool = current_user.tools.build(params[:tool] || {})
  end

  def create
    @tool = current_user.tools.create params[:tool]

    if @tool.valid?
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
