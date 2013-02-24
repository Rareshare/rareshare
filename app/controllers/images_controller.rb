class ImagesController < ApplicationController
  before_filter :tool

  def index
    @images = @tool.images.map { |image| json_for image }

    respond_to do |format|
      format.html
      format.json { render json: @images }
    end
  end

  def create
    image = @tool.images.build(params[:image])

    if image.save
      respond_to do |format|
        format.html do
          render json: [ json_for(image) ], content_type: 'text/html', layout: false
        end

        format.json do
          render json: [ json_for(image) ]
        end
      end
    else
      render json: [{ error: images.errors.full_messages.join }], :status => 304
    end
  end

  def destroy
    @tool.images.where(id: params[:id]).first.try :destroy
    head :ok
  end

  private

  def tool
    @tool = Tool.where(id: params[:tool_id]).first

    if params[:tool_id].blank? || @tool.blank?
      raise ActiveRecord::RecordNotFound
    end
  end

  def json_for(image)
    image.to_h.merge delete_type: "DELETE", delete_url: tool_image_url(@tool, image)
  end

end
