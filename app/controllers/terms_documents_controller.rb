class TermsDocumentsController < InternalController

  def create
    terms = current_user.terms_documents.create(terms_params.merge(title: terms_params[:pdf].original_filename))

    if terms.valid?
      response.headers['Location'] = terms_document_path(terms, format: :json)
      render json: terms, status: :created
    else
      render json: { error: terms.errors.full_messages.join(".") }, status: :bad_request
    end
  end

  def terms_params
    params.require(:terms_document).permit(:pdf)
  end


end
