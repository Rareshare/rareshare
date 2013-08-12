class BookingsController < InternalController

  def new
    tool = Tool.where(id: params[:tool_id]).first

    if tool.nil?
      self.not_found!
    elsif !can?(:book, tool)
      redirect_to back_or_home, flash: { error: "You cannot book your own tool." }
    else
      deadline = if params[:date].present?
        Date.parse(params[:date])
      else
        tool.earliest_bookable_date
      end

      @booking = Booking.new do |b|
        b.renter_id = current_user.id
        b.tool_id   = tool.id
        b.deadline  = deadline
        b.price     = tool.price_for(deadline, 1)
        b.currency  = tool.currency
        b.samples   = 1
        b.use_user_address = current_user.address.present?
        b.build_address
      end
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
    tool = Tool.where(id: params[:booking][:tool_id]).first

    if tool.nil?
      not_found!
    elsif !can?(:book, tool)
      redirect_to back_or_home, flash: { error: "You cannot book your own tool." }
    else
      @booking = Booking.reserve current_user, booking_params

      if @booking.valid?
        redirect_to booking_path(@booking), flash: { notice: "Booking requested!" }
      else
        flash[:error] = @booking.errors.full_messages
        render 'bookings/new'
      end
    end
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
