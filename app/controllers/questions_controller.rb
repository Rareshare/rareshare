class QuestionsController < InternalController
  def show
    question = booking.questions.find(params[:id])
    render json: question
  end

  def create
    question = booking.ask_question(question_params)

    if question.valid?
      render json: question, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reply
    question = booking.questions.find(params[:question_id])
    # response = question.question_responses.create(reply_params)
    response = question.reply_with(reply_params)

    if response.valid?
      render json: response, status: :created
    else
      render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def booking
    @booking ||= Booking.find(params[:booking_id])
  end

  def question_params
    params.require(:question).permit(:topic, :body).merge(user_id: current_user.id)
  end

  def reply_params
    params.require(:question_response).permit(:body).merge(user_id: current_user.id)
  end
end
