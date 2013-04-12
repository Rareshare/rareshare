class BookingsController < ApplicationController
  before_filter :authenticate_user!

  def new
    tool = Tool.find(params[:tool_id])

    unless tool.leaseable_by? current_user
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
      redirect_to booking_path(@booking), flash: { notice: "Booking successful!" }
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

  def destroy
    @booking = Booking.find(params[:id])

    if @booking.reserved_by?(current_user)
      @booking.cancel!
      @booking.save!
      redirect_to profile_path, flash: { notice: "Booking successfully cancelled." }
    else
      redirect_to profile_path, flash: { error: "You do not have permission to cancel this booking." }
    end
  end

  def update
    @booking = Booking.find(params[:id])

    if @booking.tool.owned_by?(current_user)
      case params[:commit]
      when /approve/i
        @booking.confirm!
        redirect_to booking_path(@booking), info: "Successfully confirmed booking."
      when /deny/i
        @booking.deny!
        redirect_to booking_path(@booking), info: "Booking was denied."
      else
        redirect_to booking_path(@booking), error: "Unrecognized booking operation."
      end
    end
  end
end
