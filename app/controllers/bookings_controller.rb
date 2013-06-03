class BookingsController < InternalController
  before_filter :authenticate_user!

  def new
    tool = Tool.find(params[:tool_id])

    unless can? :book, tool
      redirect_to :back, error: "You cannot book your own tool."
    end

    @booking = Booking.new(
      renter_id: current_user.id,
      tool_id:   tool.id,
      deadline:  params[:date],
      price:     tool.price_for(params[:date])
    )
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

    unless @booking.can_be_shown_to?(current_user)
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
  end

  def pay
    @booking = Booking.find(params[:id])

    credit_card_params = params.require(:transaction).require(:credit_card).permit(
      :number, :cvv, :expiration_date, :expiration_month, :expiration_year
    )

    result = Braintree::Transaction.sale(
      amount:      @booking.price,
      credit_card: credit_card_params,
      options:     { submit_for_settlement: true }
    )

    if result.success?
      Transaction.create! booking: @booking, customer: current_user, amount: @booking.price
      @booking.updated_by = current_user
      @booking.finalize!
      redirect_to booking_path(@booking), flash: { notify: "Booking finalized." }
    else
      flash[:error] = result.message
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
      :address_attributes => address_attributes
    )
  end
end
