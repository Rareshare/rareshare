class BookingEditsController < InternalController
  before_action :find_booking_edit, only: [:create, :edit, :update, :confirm, :decline, :destroy]
  before_action :find_booking, only: [:create, :update, :destroy, :confirm, :decline]

  def new
    @booking = Booking.find(params[:booking_id])
    @booking_edit = BookingEdit.new(booking_id: @booking.id)
    authorize! :owner_edit, @booking
  end

  def create
    authorize! :owner_edit, @booking

    if @booking_edit.save
      flash[:success] = "Successfully edited booking"

      if @booking.can_owner_edit?
        @booking.updated_by = current_user
        @booking.owner_edit!
      end
    else
      flash[:error] = @booking_edit.errors.full_messages
    end

    redirect_to @booking
  end

  def edit
    authorize! :maanage, @booking_edit
  end

  def update
    authorize! :manage, @booking_edit

    if @booking_edit.update_attributes(booking_edit_params)
      flash[:success] = "Successfully updated your edit request."
    else
      flash[:error] = @booking_edit.errors.full_messages
    end

    redirect_to @booking
  end

  def confirm
    authorize! :respond, @booking_edit
    @booking_edit.confirm!
    @booking.update_column(:price, @booking.price + @booking_edit.change_amount)
    @booking.updated_by = current_user
    @booking.renter_respond_to_edit!

    redirect_to @booking
  end

  def decline
    authorize! :respond, @booking_edit
    @booking_edit.decline!
    @booking.updated_by = current_user
    @booking.renter_respond_to_edit!

    redirect_to @booking
  end

  def destroy
    authorize! :manage, @booking_edit

    @booking_edit.destroy
    flash[:success] = "Successfully canceled the edit."
    if @booking.booking_edits.pending.empty?
      @booking.updated_by = current_user
      @booking.cancel_owner_edit!
    end
    redirect_to @booking
  end

  private

  def find_booking
    @booking = @booking_edit.booking
  end

  def find_booking_edit
    if params[:id]
      @booking_edit = BookingEdit.find(params[:id])
    else
      @booking_edit = BookingEdit.new(booking_edit_params)
    end
  end

  def booking_edit_params
    params.require(:booking_edit).permit(:booking_id, :change_amount, :memo)
  end
end