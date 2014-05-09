class BookingsController < InternalController

  def new
    tool = Tool.where(id: params[:tool_id]).first

    if tool.nil?
      self.not_found!
    elsif !can?(:book, tool)
      redirect_to back_or_home, flash: { error: "You cannot book your own tool." }
    else
      @booking = Booking.default(current_user, tool, params.permit(:date, :subtype))
    end
  end

  def index
    if params[:month].present? && params[:month] =~ /(\d{4})-(\d{2})/
      year, month = [ $1, $2 ].map &:to_i
    else
      now = Date.today
      year, month = now.year, now.month
    end

    @calendar = Calendar.new(year: year, month: month, user: current_user)
  end

  def create
    save_draft_or_reserve
  end

  def show
    @booking = Booking.find(params[:id])

    unless can? :read, @booking
      redirect_to back_or_home, flash: { error: "You don't have permission to view this booking." }
    end
  end

  def cancel
    @booking = Booking.find(params[:id])

    unless can? :cancel, @booking
      redirect_to back_or_home, flash: { error: "This booking cannot be cancelled." }
    end
  end

  def approve
    @booking = Booking.find(params[:id])

    unless can? :confirm, @booking
      redirect_to back_or_home, flash: { error: "This booking cannot be approved." }
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.updated_by = current_user

    case params[:commit]
    when /save/i
      authorize! :update_draft, @booking
      @booking.assign_attributes(booking_params)
      save_draft_or_reserve
    when /reserve/i
      authorize! :update_draft, @booking
      @booking.assign_attributes(booking_params)
      save_draft_or_reserve
    when /approve/i
      authorize! :confirm, @booking
      @booking.confirm!
      redirect_to booking_path(@booking), notice: "Successfully confirmed booking."
    when /deny/i
      authorize! :deny, @booking
      @booking.deny!
      redirect_to booking_path(@booking), notice: "Booking was denied."
    when /owner_edit/i
      authorize! :owner_edit, @booking
      @booking.owner_edit!
      redirect_to booking_path(@booking), notice: "Successfully edited booking."
    when /cancel/i
      authorize! :cancel, @booking
      @booking.cancel!
      redirect_to profile_path, notice: "Booking was cancelled."
    when /finalize/i
      authorize! :finalize, @booking
      @booking.finalize!
      redirect_to profile_path, notice: "Successfully finalized booking."
    when /begin/i
      authorize! :begin, @booking
      @booking.begin!
      redirect_to profile_path, notice: "Booking now being processed."
    when /complete/i
      authorize! :complete, @booking
      @booking.complete!
      redirect_to profile_path, notice: "Booking has finished processed."
    else
      redirect_to booking_path(@booking), error: "Unrecognized booking operation."
    end
  end

  def finalize
    @booking = Booking.find(params[:id])
    if @booking.owner.stripe_access_token
      authorize! :finalize, @booking
    else
      flash[:error] = "The owner has not connected with Stripe yet."
      redirect_to @booking
    end
  end

  def pay
    @booking = Booking.find(params[:id])

    transaction_params = params.require(:transaction).permit(:stripe_token, :shipping_service)

    @booking.attributes = transaction_params

    if @booking.pay!
      redirect_to booking_path(@booking), notice: "Successfully finalized booking."
    else
      flash[:error] = @booking.errors.full_messages
      render 'finalize'
    end
  end

  private

  def booking_params
    params.require(:booking).permit(
      :tool_id,
      :tool_price_id,
      :tool_price_type,
      :expedited,
      :deadline,
      :tos_accepted,
      :sample_description,
      :sample_deliverable,
      :sample_transit,
      :sample_disposal,
      :disposal_instructions,
      :address_id,
      :use_user_address,
      :shipping_package_size,
      :units,
      :address_attributes => address_attributes
    )
  end

  def save_draft_or_reserve
    tool = Tool.where(id: params[:booking][:tool_id]).first

    if tool.nil?
      not_found!
    elsif !can?(:book, tool)
      redirect_to back_or_home, flash: { error: "You cannot book your own tool." }
    else
      @booking ||= Booking.new(booking_params)

      if params[:commit] == t('bookings.action_type.draft')
        @booking.save_draft(current_user)
        redirect_to booking_path(@booking), flash: { notice: "Booking draft saved!" }
      else
        @booking.reserve(current_user)

        if @booking.valid?
          redirect_to booking_path(@booking), flash: { notice: "Booking requested!" }
        else
          flash[:error] = @booking.errors.full_messages
          render 'bookings/new'
        end
      end
    end
  end
end
