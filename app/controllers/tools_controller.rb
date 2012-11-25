class ToolsController < ApplicationController
  before_filter :authenticate_user!

  add_breadcrumb 'Tools', ''

  def show
    @tool = Tool.find(params[:id])
    add_breadcrumb @tool.display_name, tool_path(@tool)
  end

end