class BookingsController < InternalController
  before_filter :authenticate_user!

  def new
    tool = Tool.find(params[:tool_id])

    unless can? :book, tool
      redirect_to :back, error: "You cannot book your own tool."
    end

    @booking = Booking.new.tap do |l|
      l.renter_id  = current_user.id
      l.tool_id    = tool.id
      l.deadline   = params[:date]
      l.price      = tool.price_for(params[:date])
    end
  end

  def create
    @booking = current_user.request_reservation!(params[:booking])

    if @booking.valid?
      redirect_to booking_path(@booking), flash: { notice: "Booking requested!" }
    else
      render 'bookings/new'
    end
  end

  def show
    @booking = Booking.find(params[:id])

    unless @booking.can_be_shown_to?(current_user)
      redirect_to profile_path, flash: { error: "You don't have permission to view the requested booking." }
    end
  end

  def update
    @booking = Booking.find(params[:id])

    case params[:commit]
    when /approve/i
      authorize! :confirm, @booking
      @booking.transition! :confirm, current_user
      redirect_to booking_path(@booking), info: "Successfully confirmed booking."
    when /deny/i
      authorize! :deny, @booking
      @booking.transition! :deny, current_user
      redirect_to booking_path(@booking), info: "Booking was denied."
    when /cancel/i
      authorize! :cancel, @booking
      @booking.transition! :cancel, current_user
      redirect_to profile_path, info: "Booking was cancelled."
    else
      redirect_to booking_path(@booking), error: "Unrecognized booking operation."
    end
  end
end
