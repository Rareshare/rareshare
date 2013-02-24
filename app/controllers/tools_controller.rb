class ToolsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tools = current_user.tools.all
  end

  def show
    @tool = Tool.find(params[:id])
    add_breadcrumb @tool.display_name, tool_path(@tool)
  end

  def new
    @tool = current_user.tools.build(params[:tool] || {})
    add_breadcrumb "New " + @tool.display_name, new_tool_path
  end

  def edit
    @tool = Tool.find(params[:id])
    add_breadcrumb "Edit " + @tool.display_name, edit_tool_path(@tool)
  end

  def update
    @tool = Tool.find(params[:id])

    if @tool.update_attributes(params[:tool])
      redirect_to tool_path(@tool), flash: { notify: "Tool saved."}
    else
      render 'tools/edit'
    end
  end

  def create
    @tool = current_user.tools.create params[:tool]

    if @tool.valid?
      redirect_to tool_path(@tool), flash: { notify: "Tool created."}
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

  def to_jq_upload(tool)
    {
      "delete_url" => picture_path(:id => id),
      "delete_type" => "DELETE"
    }
  end
end
