class BookingEditRequestsController < ApplicationController
  before_action :find_booking_edit_request, only: [:create, :edit, :update, :check, :accept, :decline, :destroy]
  before_action :find_booking, only: [:create, :edit, :update, :check, :destroy, :accept, :decline]

  def new
    @booking = Booking.find(params[:booking_id])
    @booking_edit_request = BookingEditRequest.new(booking_id: @booking.id)

    authorize! :request_edit, @booking
  end

  def create
    authorize! :request_edit, @booking

    if @booking_edit_request.save
      flash[:success] = "Successfully made the edit request"

      if @booking.can_request_edit?
        @booking.updated_by = current_user
        @booking.request_edit!
      end
    else
      flash[:error] = @booking_edit_request.errors.full_messages
    end

    redirect_to @booking
  end

  def edit
    authorize! :manage, @booking_edit_request
  end

  def update
    authorize! :manage, @booking_edit_request
    if @booking_edit_request.update_attributes(booking_edit_request_params)
      flash[:success] = "Succesfully updated your edit request."
    else
      flash[:error] = @booking_edit_request.errros.full_messages
    end

    redirect_to @booking
  end

  def check
    authorize! :respond, @booking_edit_request
  end

  def accept
    authorize! :respond, @booking_edit_request

    if @booking_edit_request.update_attributes(booking_edit_request_params)
      flash[:success] = "Succesfully accepted the edit request."
      @booking_edit_request.accept!

      @booking.apply_adjustment(@booking_edit_request.adjustment)


      @booking.updated_by = current_user
      @booking.renter_respond_to_edit_request!
    else
      flash[:error] = @booking_edit_request.errors.full_messages
    end

    redirect_to @booking
  end

  def decline
    authorize! :respond, @booking_edit_request

    @booking_edit_request.decline!
    @booking.updated_by = current_user
    @booking.renter_respond_to_edit_request!

    redirect_to @booking
  end

  def destroy
    authorize! :respond, @booking_edit_request

    @booking_edit_request.destroy
    flash[:success] = "Successfully canceled the edit request."
    if @booking.booking_edit_requests.pending.empty?
      @booking.updated_by = current_user
      @booking.cancel_edit_request!
    end

    redirect_to @booking
  end

  private

  def find_booking
    @booking = @booking_edit_request.booking
  end

  def find_booking_edit_request
    if params[:id]
      @booking_edit_request = BookingEditRequest.find(params[:id])
    else
      @booking_edit_request = BookingEditRequest.new(booking_edit_request_params)
    end
  end

  def booking_edit_request_params
    params.require(:booking_edit_request).permit(:booking_id, :adjustment, :memo)
  end
end