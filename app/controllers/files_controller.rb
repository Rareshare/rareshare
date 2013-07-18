class FilesController < InternalController

  def create
    file = StoredFile.where(url: file_params[:url]).first || StoredFile.create(file_params)

    if file.valid?
      redirect_to file_path(file.id)
    else
      render json: { error: file.errors.full_messages.join(".") }
    end
  end

  def show
    if file = StoredFile.where(id: params[:id]).first
      render json: file
    else
      render json: { error: "File not found" }
    end
  end

  private

  def file_params
    params.require(:file).permit(
      :name,
      :url,
      :size,
      :content_type
    ).merge(
      user_id: current_user.id
    )
  end

end
