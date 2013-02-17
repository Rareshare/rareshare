class LeasesController < ApplicationController
  before_filter :authenticate_user!

  def new
    tool = Tool.find(params[:tool_id])

    @lease = Lease.new.tap do |l|
      l.lessor_id  = tool.owner_id
      l.lessee_id  = current_user.id
      l.tool_id    = tool.id
      l.started_at = params[:date]
      l.ended_at   = params[:date]
    end

    if @lease.lessor_id == @lease.lessee_id
      redirect_to :back, error: "You cannot lease your own tool."
    end
  end

  def create
    @lease = current_user.request_reservation!(params[:lease])

    if @lease.valid?
      redirect_to profile_path, flash: { notice: "Lease successful!" }
    else
      render 'leases/new'
    end
  end

  def destroy
    @lease = Lease.find(params[:id])

    if @lease.reserved_by?(current_user)
      @lease.cancel!
      @lease.save!
      redirect_to profile_path, flash: { notice: "Lease successfully cancelled." }
    else
      redirect_to profile_path, flash: { error: "You do not have permission to cancel this lease." }
    end
  end

  def update
    @lease = Lease.find(params[:id])

    if current_user.id = @lease.lessor_id
      case params[:commit]
      when /confirm/i
        @lease.confirm!
        redirect_to profile_path, info: "Successfully confirmed lease."
      when /deny/i
        @lease.deny!
        redirect_to profile_path, info: "Lease was denied."
      else
        redirect_to profile_path, error: "Unrecognized lease operation."
      end
    end
  end
end
