class BookingsController < InternalController

  def new
    tool = Tool.find(params[:tool_id])

    unless can? :book, tool
      redirect_to :back, error: "You cannot book your own tool."
    end

    @booking = Booking.new do |b|
      b.renter_id = current_user.id
      b.tool_id   = tool.id
      b.deadline  = params[:date]
      b.price     = tool.price_for(params[:date], 1)
      b.currency  = tool.currency
      b.samples   = 1
      b.use_user_address = current_user.address.present?
      b.build_address
    end
  end

  def create
    @booking = Booking.reserve current_user, booking_params

    if @booking.valid?
      redirect_to booking_path(@booking), flash: { notice: "Booking requested!" }
    else
      flash[:error] = @booking.errors.full_messages
      render 'bookings/new'
    end
  end

  def show
    @booking = Booking.find(params[:id])

    unless can? :read, @booking
      redirect_to profile_path, flash: { error: "You don't have permission to view the requested booking." }
    end
  end

  def cancel
    @booking = Booking.find(params[:id])

    unless can? :cancel, @booking
      redirect_to profile_path, flash: { error: "This booking cannot be cancelled." }
    end
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.updated_by = current_user

    case params[:commit]
    when /approve/i
      authorize! :confirm, @booking
      @booking.confirm!
      redirect_to booking_path(@booking), notice: "Successfully confirmed booking."
    when /deny/i
      authorize! :deny, @booking
      @booking.deny!
      redirect_to booking_path(@booking), notice: "Booking was denied."
    when /cancel/i
      authorize! :cancel, @booking
      @booking.cancel!
      redirect_to profile_path, notice: "Booking was cancelled."
    when /finalize/i
      authorize! :finalize, @booking
      @booking.finalize!
      redirect_to profile_path, notice: "Successfully finalized booking."
    else
      redirect_to booking_path(@booking), error: "Unrecognized booking operation."
    end
  end

  def finalize
    @booking = Booking.find(params[:id])
    authorize! :finalize, @booking
  end

  def pay
    @booking = Booking.find(params[:id])

    transaction_params = params.require(:transaction).permit(:stripe_token, :shipping_service)

    @booking.update_attributes(transaction_params)

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
      :samples,
      :address_attributes => address_attributes
    )
  end
end
