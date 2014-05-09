class BookingEditsController < InternalController
  before_action :find_booking_edit, only: [:edit, :update, :destroy]

  def new
    @booking = Booking.find(params[:booking_id])
    @booking_edit = BookingEdit.new(booking_id: @booking.id)
  end

  def create
    @booking_edit = BookingEdit.new(booking_edit_params)

    if @booking_edit.save
      flash[:success] = "Successfully edited booking"
    else
      flash[:error] = booking_edit.errors.full_messages
    end

    redirect_to @booking_edit.booking
  end

  def edit
  end

  def update
    if @booking_edit.update_attributes(booking_edit_params)
      flash[:success] = "Successfully updated your edit request."
    else
      flash[:error] = booking_edit.errors.full_messages
    end

    redirect_to @booking_edit.booking
  end

  def destroy
    @booking_edit.destroy
    flash[:success] = "Successfully canceled the edit."
    redirect_to @booking_edit.booking
  end

  private

  def find_booking
    @booking = Booking.find(params[:booking_id])
  end

  def find_booking_edit
    @booking_edit = BookingEdit.find(params[:id])
  end

  def booking_edit_params
    params.require(:booking_edit).permit(:booking_id, :change_amount, :memo)
  end
end