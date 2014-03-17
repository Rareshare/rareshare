class FilesController < InternalController

  def create
    file = params[:uploads].try(:[], :file)
    content_type = file.try(:content_type)

    file_class = case content_type
    when /image\/*/
      ImageFile
    when /application\/pdf/
      PdfFile
    end

    if file_class.blank?
      render json: { error: "Not acceptable: #{content_type}" }, status: :not_acceptable
    else
      query = file_class.where(user_id: current_user.id, name: file.original_filename)
      file = query.first || query.create(file: file, content_type: content_type, size: file.size)

      if file.valid?
        response.headers['Location'] = file_path(file, format: :json)
        render json: file, status: :created
      else
        render json: { error: terms.errors.full_messages.join(".") }, status: :bad_request
      end
    end
  end

  def show
    if file = StoredFile.where(id: params[:id]).first
      render json: file
    else
      render json: { error: "File not found" }, status: :not_found
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
