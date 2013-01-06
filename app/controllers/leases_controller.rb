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
end
