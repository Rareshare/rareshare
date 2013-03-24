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
      redirect_to profile_path, flash: { notice: "Booking successful!" }
    else
      raise @booking.errors.full_messages.inspect
      render 'bookings/new'
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

    if current_user.id = @booking.lessor_id
      case params[:commit]
      when /confirm/i
        @booking.confirm!
        redirect_to profile_path, info: "Successfully confirmed booking."
      when /deny/i
        @booking.deny!
        redirect_to profile_path, info: "Booking was denied."
      else
        redirect_to profile_path, error: "Unrecognized booking operation."
      end
    end
  end
end
